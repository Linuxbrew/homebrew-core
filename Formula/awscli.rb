class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.10.tar.gz"
  sha256 "ff9a6f3bcab482d120b4fec10ff47bb47cafe49b3d7cd59bf7b42197051cacfe"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "05bd63ee4669aac00204a4606273875654655efe37a40bbfe0f4c5cc3f7b069d" => :catalina
    sha256 "4ddd6d30c56eee7991cf14069d97d70896959f01c05a22782aabe861da3f7e62" => :mojave
    sha256 "004bfcc8b0f71d49ac7ae1764191faefe9c91eaa3fe2c11d5baaec957e445889" => :high_sierra
    sha256 "dc0e934236d2d4278d6c78eb301626fe93e267e2610a829b9f47108e1be0cd75" => :x86_64_linux
  end

  depends_on "libyaml" unless OS.mac?
  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python@3.8"

  uses_from_macos "groff"

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
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
