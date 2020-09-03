class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.0.0.tar.gz"
  sha256 "467509b4db3da0db1360e3f22c233f7c8bb321f576ebcb69166041da5de45100"

  bottle do
    cellar :any_skip_relocation
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
