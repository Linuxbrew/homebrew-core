# mdbook: Build a bottle for Linuxbrew
class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.3.tar.gz"
  sha256 "20f3775994664e49dc17dd4e9a3415e4193b4b861ad7f35f299b11e23ab4298e"

  bottle do
    cellar :any_skip_relocation
    sha256 "952b4298e881fda98dbd1311338588d495504a50f8d48b1277fd69fced6ad1ce" => :catalina
    sha256 "8b1a774bf84bfdbd9ed746dd691529e9018988d262502ebb7dee54cf3fe3e0c7" => :mojave
    sha256 "cfafd1902a398e9412ba4e7864075f66fa268ac0d1a5c150e8d9472e3e45e707" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
