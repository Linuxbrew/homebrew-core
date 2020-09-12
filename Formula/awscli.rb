class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.48.tar.gz"
  sha256 "1c0def71527c607e24a2949a67ea60745dc5bcca72211c61be4233d686721942"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "e2568d1fd54df10a00bb3722038bd19f510c7f01bcbed889ff77b6f74d5abb7f" => :catalina
    sha256 "f045f77e8e74167c1b27daca4bf1a3e96e8446990f70112c43b4448acc369c9d" => :mojave
    sha256 "907821d5d4cad35c2a1f54a5ab0ce90a8e97e9bd1831bd8ac2784f9f359afe28" => :high_sierra
  end

  depends_on "python@3.8"

  uses_from_macos "groff"

  on_linux do
    depends_on "libyaml"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "-r", "requirements.txt",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS

    system libexec/"bin/python3", "scripts/gen-ac-index", "--include-builtin-index"
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
    assert_include Dir["#{libexec}/lib/python3.8/site-packages/awscli/data/*"],
                   "#{libexec}/lib/python3.8/site-packages/awscli/data/ac.index"
  end
end
