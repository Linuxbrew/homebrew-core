class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef092ec60093190857b558fd9a663ca0c6d0356bb9af7798be21cf466678f27e" => :sierra
    sha256 "d2719509725f4c1fad3a53c32de18aff5d45685fb35ae352f1d51fc61e566f4a" => :el_capitan
    sha256 "d002876c03742fc7ec4157fff598e7c11ed1e62f97ce1b217f8b089db87e43ed" => :yosemite
    sha256 "20dd7125d138e05021b473d026190d8f4652e807afcfe057614e5c2e66ce0ed1" => :mavericks
    sha256 "4eebce66edee44582178986d2f36e98392b97cf36cf683aaf3b353627cb8cf3a" => :x86_64_linux # glibc 2.19
  end

  depends_on :macos => :lion
  depends_on :java => "1.7+"
  depends_on "zlib" unless OS.mac?

  def install
    if OS.mac?
      system "make", "use-clang=true"
      bin.install Dir["build/macosx-*/avian*"]
      lib.install Dir["build/macosx-*/*.dylib", "build/macosx-*/*.a"]
    else
      inreplace "makefile", "warnings = -Wall -Wextra -Werror",
                            "warnings = -Wall -Wextra"
      system "make"
      bin.install Dir["build/linux-*/avian*"]
      lib.install Dir["build/linux-*/*.so", "build/linux-*/*.a"]
    end
  end

  test do
    (testpath/"Test.java").write <<-EOS.undent
      public class Test {
        public static void main(String arg[]) {
          System.out.print("OK");
        }
      }
    EOS
    system "javac", "Test.java"
    assert_equal "OK", shell_output("#{bin}/avian Test")
  end
end
