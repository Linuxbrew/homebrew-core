class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.2.0.tar.gz"
  sha256 "39886f4bc3985d4aefbae6fc88532499ac2c39cbabc33d860bba6d355158e17d"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c2c76dbc1116ca20a1d140f688c6f2f41197d5521a7cb31435c3ced2f625000"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ENV["GOOS"] = "linux"
    ENV["GOARCH"] = "amd64"

    flags = "-X main.Version=#{version} -s -w"

    system "go", "build", "-ldflags=#{flags}"
    bin.install "aws-vault"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help",
      shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
