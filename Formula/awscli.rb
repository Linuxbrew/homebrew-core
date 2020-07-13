class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.0.29.tar.gz"
  sha256 "3d073b97034070a218ccde4c6cd33b29f96f32344b535e75564ee0b52fa5fc2c"
  head "https://github.com/aws/aws-cli.git", :branch => "v2"

  bottle do
    sha256 "b38dab3562270529c5e57d34b151ac0b31da89aa1ca8316682da6e34ff243fc5" => :catalina
    sha256 "50bfad8bd4a17d193a7c9e3de5143900842ce0193ff3e842f2d2f7a2a311ec29" => :mojave
    sha256 "c11341c9f3500080869c4c5f4a31163d527da5bb90f8068a92403c1c543c7643" => :high_sierra
    sha256 "cb627b5c480713f233a5092c7e0a1f35e4c62b76ed37ef3b7614ef3f244c039d" => :x86_64_linux
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
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
