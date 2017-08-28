class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  if OS.mac?
    url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.0/astyle_3.0_macos.tar.gz"
    sha256 "d113aa5942219699262ceddd1dde35c66b20bf6cc5eac04d27d398ca7a460eb3"
  elsif OS.linux?
    url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.0/astyle_3.0_linux.tar.gz"
    sha256 "983e4fe87f20427ddf0d06fa5ba046b5ee95347f9ada33a681af3892426a4ff3"
  end
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ed8641bb284828c0e753b6d2570c317f4275a9ee5845c33ac90835dd319258" => :sierra
    sha256 "b5da4fab0010f84a6623585c99e5468492e0a2c8dd1a77680bd4c51b900c0272" => :el_capitan
    sha256 "69819972ffefb908f5186f01b688d32c28e9ea2ca2a0d62c5b2850e686e1aefa" => :yosemite
    sha256 "737a512c70bbb8dc2cef32483eccba3de4e4814f9cf8c1e83c550d4f548b035f" => :x86_64_linux # glibc 2.19
  end

  def install
    cd "src" do
      dir = OS.mac? ? "mac" : "gcc"
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/#{dir}/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<-EOS.undent
      int main()
      {
          return 0;
      }
    EOS
  end
end
