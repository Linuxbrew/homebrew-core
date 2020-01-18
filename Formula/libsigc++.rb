class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.2.tar.xz"
  sha256 "4b77676de1e74774ec456bcc6ac6f04a2791a12cc1fe07f8305d4c3c86e2f339"

  bottle do
    cellar :any
    sha256 "793bb22cf3d7566a5ee346dd110fd2eba97b1ac91c16a9846ffb54af59cc43aa" => :catalina
    sha256 "02ea0ed1876ad347cdc1a4b0223066f6fb5ced0dd955373834aa2da68404aad7" => :mojave
    sha256 "ab541bdf6cb5d8c223213796054db86e8896c11fe3a68c79a2a179d85b019751" => :high_sierra
  end

  depends_on :macos => :high_sierra if OS.mac? # needs C++17
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "gcc@7"

    fails_with :gcc => "4"
    fails_with :gcc => "5"
    fails_with :gcc => "6"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    ENV["CXX"] = Formula["gcc@7"].opt_bin/"c++-7" unless OS.mac?
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <sigc++/sigc++.h>

      void on_print(const std::string& str) {
        std::cout << str;
      }

      int main(int argc, char *argv[]) {
        sigc::signal<void(const std::string&)> signal_print;

        signal_print.connect(sigc::ptr_fun(&on_print));

        signal_print.emit("hello world\\n");
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
