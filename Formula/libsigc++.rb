class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.6.tar.xz"
  sha256 "b70edcf4611651c54a426e109b17196e1fa17da090592a5000e2d134c03ac5ce"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5b79b43ac38795ae18d82d6762cf36039988c4cec8ff56afc2005d2034084c3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on macos: :high_sierra if OS.mac? # needs C++17

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    ENV["CXX"] = Formula["gcc"].opt_bin/"c++-10" unless OS.mac?
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
