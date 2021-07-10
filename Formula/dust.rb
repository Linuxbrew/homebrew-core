class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.6.0.tar.gz"
  sha256 "4d13a2edf38ab7bfc01b700f5856c92aa3772249a203b34247c3b2c7dd8fa574"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a8fd300c0636347e98ae22025c13477094feaf6d2812a510c440eb311981a16"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9211d15bd64b618d8c055916f62586619a812c0365c6bebfdaf12408f63aeaf"
    sha256 cellar: :any_skip_relocation, catalina:      "aa1ae392db8649baa12180724f746ed4e217cee48598f5c62e7e9bcf3eaf35a1"
    sha256 cellar: :any_skip_relocation, mojave:        "047f772ba838c1c1677c37132cb12bf67a574c05a6b1a7038d5606ea595b2dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2d5e1b056782b471dbf06c4e09cf437105c71eca807ed6528773c5044243599" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
