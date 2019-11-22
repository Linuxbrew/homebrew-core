class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/2b/7a/e0e905e6f4e7d90b99fcaa94f56a24f67852c75d38399997073b006487cb/gimme%20aws%20creds-2.1.1.tar.gz"
  sha256 "87ab4a0bd1ce758f24c8302416779c38ca376cf38a58e68fe332512071004c5a"

  bottle do
    cellar :any
    sha256 "d01e5dff6237fea761d6f28194aed325e7de37278fe03454073f8a4e4c22f84c" => :catalina
    sha256 "32081c09f2632be12fd81c320dd1868b42e139bf5c1d5cf5baa1b9a13d6b14c2" => :mojave
    sha256 "316cff81933b118665b1bda8ec13b8c3f30f344aea5c3956c96d31a34732090c" => :high_sierra
  end

  depends_on "python"
  unless OS.mac?
    depends_on "pkg-config" => :build
  end
  uses_from_macos "libffi"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "gimme-aws-creds"
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    output = pipe_output("#{bin}/gimme-aws-creds --action-configure 2>&1", "TESTPROFILE\nhttps://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "Okta Configuration Profile Name", output
    assert_match "[TESTPROFILE]", config_file.read

    installed_version = shell_output("#{bin}/gimme-aws-creds --version")
    assert_match version.to_s, installed_version
  end
end
