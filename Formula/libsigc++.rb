class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.6.tar.xz"
  sha256 "b70edcf4611651c54a426e109b17196e1fa17da090592a5000e2d134c03ac5ce"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "34fc45a5a4a36a592f6cb4b1671e65fddea15b3df12dd114359a5ca3101f3665"
    sha256 cellar: :any, big_sur:       "eea9483112f22c255c7b783333a5a48b90e2fb0747ad00f0ed4b37275481b93a"
    sha256 cellar: :any, catalina:      "5f7d8b6e6043bcab63f7f5675746f4d94f447cde8a48513c9db7b36b5a527e05"
    sha256 cellar: :any, mojave:        "6f3562f317a110489a2df296f8b8b3cb8bc37295b6aa5d306a5c0078f7fdb7cc"
    sha256 cellar: :any, x86_64_linux:  "c269dd0bb75627eebb1370dd03a41db43f4a0cc8798550879cd7282b2deaaeba"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on macos: :high_sierra if OS.mac? # needs C++17
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "gcc@7"

    fails_with gcc: "4"
    fails_with gcc: "5"
    fails_with gcc: "6"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
