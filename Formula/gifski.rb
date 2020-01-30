# gifski: Build a bottle for Linux
class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.10.1.tar.gz"
  sha256 "679474873f17e077036e1ffc19a37c23db1a24b27e880b25aed4620babbfe715"

  bottle do
    cellar :any_skip_relocation
    sha256 "7885c2a2a873c0c83a5190c2f83799b520d51fc9a26cc508928baf0543662a36" => :catalina
    sha256 "22b1f168132d3df440629e225e10cdf6ca7c728dc9209171b78cee446d466e67" => :mojave
    sha256 "1ba054d25b36ee72fba66d8fe109c087a2b6ff085b7bd336de3a1c01f042dc91" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
