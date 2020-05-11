class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.3/xmake-v2.3.3.tar.gz"
  sha256 "851e01256c89cb9c86b6bd7327831b45809a3255daa234d3162b1db061ca44ae"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64730570a22a08c43182c2f78c10072079df6b3c2bad5b77e8a6f4b480fd231b" => :catalina
    sha256 "bb2637686962b81df84cd9e4e12b6bfc33b536a883494ec4cc60839234bb4fce" => :mojave
    sha256 "b5d31f8c33b2bdd3631122774b81bd0ac1997336aa170ff6b49014f8e237f41a" => :high_sierra
  end

  depends_on "readline" unless OS.mac?

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
