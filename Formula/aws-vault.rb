class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v5.4.3.tar.gz"
  sha256 "2174413fd5ea7eb2f7ee0bbc393667a1044800e108ab6b8300331ec15d9ed01a"

  bottle do
    cellar :any_skip_relocation
    sha256 "59fe922044b470e16fc98f2a34e6c1b5c422dc3eb68d7b69e6d1e88dd9c29632" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on :linux

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
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help",
      shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
