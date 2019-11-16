class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v4.7.1.tar.gz"
  sha256 "a63163f2d1d344da19621c0b1d15dd2ed952abd2a7aa5e8f88f000ad71e6630a"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd00cb1f1242e6eb329cbe070a5b0eb15c720466cc5a07428a837538fac90e10" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "linux"
    ENV["GOARCH"] = "amd64"

    flags = "-X main.Version=#{version} -s -w"

    system "go", "build", "-ldflags=#{flags}"
    bin.install "aws-vault"

    zsh_completion.install "completions/zsh/_aws-vault"
    bash_completion.install "completions/bash/aws-vault"
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help", shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
