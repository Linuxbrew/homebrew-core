class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.3.tar.gz"
  sha256 "ccd47a2e6cc5ee3081773fc0fe45d9a0270f079a4c980ac9c6697dd6163b1740"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49ca88c99f74eeace8a0c9198fd168c8569eef5f0a2f3f9ed13526eccc3a10d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "43ea937cb73d403f2a8ba3bdd1cdcbbb3314757bda512e14c8c7e8f49b927f42"
    sha256 cellar: :any_skip_relocation, catalina:      "7db2f8e4c29a063bbeb746dee6a5cec986f460743d7667dcc831a59664871263"
    sha256 cellar: :any_skip_relocation, mojave:        "3af7bfc48d5d89a04c00b6ef5cd96e9a3a052fadbc4d263c51ed840f9a49a2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b807e4f7a18944a22150235e0deb7a77e9c32f80017b241c8af067b0ee2c6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
