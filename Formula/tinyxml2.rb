class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/8.0.0.tar.gz"
  sha256 "6ce574fbb46751842d23089485ae73d3db12c1b6639cda7721bf3a7ee862012c"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc187de7b8ecdaae5ca53fb68c940d01dd30d13d635a57dda778f5577ffaaefa" => :big_sur
    sha256 "de43d8d170826747b593e29cff70f84fba2e35aef5c25bec5c02c406c29bbf84" => :catalina
    sha256 "65527a3b8385c01fabbaeef1ff1dc3cc301dcf5f49e0875d210d80fc5181379d" => :mojave
    sha256 "eaacca900292a86dc5d4e95e2a71042a6e2fe7e766341d0b5078cf99cd25c0da" => :high_sierra
    sha256 "8444b2056b5eaeb4f758c80b3c383d26fe1119b6f5d89b0385477049939d471e" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2",
                   *("-I#{include}" unless OS.mac?),
                   *("-Wl,-rpath=#{lib}" unless OS.mac?),
                   "-o", "test"
    system "./test"
  end
end
