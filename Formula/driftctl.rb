class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.7.0.tar.gz"
  sha256 "b1f842f04b0b51d5bcf563a70e9842b38b158e24e67c474410b6027a85b43fbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "506b4a0dc52267df576bb25c6aef631c2d9a8cfc2c05e9056994e5744ac149d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "946955b9da3d6f81bbf8126e69fa1bc7a99f2122ec3147bcad3dc606c22e5bc8"
    sha256 cellar: :any_skip_relocation, catalina:      "4161becf9e220b70520c1ed7db5e8fa5bb435cbf0d391fe6b3eef02a9e39944c"
    sha256 cellar: :any_skip_relocation, mojave:        "b1d137efb4489937123c159cef1fc1fd2e440664e4bbc5ea552d9d0a83a31c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b0850bef6ee055b95a97e5b553ed6bb2093d870ae8a5e2ff347e8e63e371bca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/cloudskiff/driftctl/build.env=release
             -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}",
             *std_go_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
