class Fizsh < Formula
  desc "Fish-like front end for ZSH"
  homepage "https://github.com/zsh-users/fizsh"
  url "https://downloads.sourceforge.net/project/fizsh/fizsh-1.0.9.tar.gz"
  sha256 "dbbbe03101f82e62f1dfe1f8af7cde23bc043833679bc74601a0a3d58a117b07"
  head "https://github.com/zsh-users/fizsh", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "334ceff9d649e87f87be9d3f561ee38221f8c87712a3b506b145191dc51fc4bd" => :sierra
    sha256 "334ceff9d649e87f87be9d3f561ee38221f8c87712a3b506b145191dc51fc4bd" => :el_capitan
    sha256 "334ceff9d649e87f87be9d3f561ee38221f8c87712a3b506b145191dc51fc4bd" => :yosemite
    sha256 "d25f3467f58d11b38efac3595c9e9244fcd558823d2d2e64a0a6744c8330099a" => :x86_64_linux # glibc 2.19
  end

  depends_on "zsh"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/fizsh -c \"echo hello\"").strip
  end
end
