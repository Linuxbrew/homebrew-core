class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.11.tar.gz"
  sha256 "7819d70d6a4136896409e627bcfac0726d9e5f9a21fac80529f97661c71318d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "e91f7c5ca5c8562b0c5f21a611387a4c84d0231268e2fb02d9dcab5c5a0028cf"
    sha256 cellar: :any_skip_relocation, catalina:     "566aa80fa3b9b54144ebd2d95e9c8392c23324a061c4d1c443c9b85e9e8ddd5b"
    sha256 cellar: :any_skip_relocation, mojave:       "e5abb77d1e7ae165e9007926c8df655351259c9130ecab421c25a8ed9db3522d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8089e09708a75d7d7a1803f5da0659b7b3c70e90c57d149bcefaaaf8323d20ae"
  end

  depends_on "luajit" unless OS.mac?

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
