class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.4.tar.xz"
  sha256 "a3a37410186379df1908957e7aba7519bdcf5bcc8ed70ee8dfea9362c393d545"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "d2de70313193afa35217b73be9c91f1486351149b84e175bbab86ca568f2da33" => :big_sur
    sha256 "6e77a5e5ac7b87088e47fc57c50567e0528ac17a451d219470b274fd41f8b57f" => :catalina
    sha256 "c8ec93f63daaf73d3141d1e0a1e96a8fc208dbc9e872595f5fce9b4bd7025238" => :mojave
    sha256 "16ff1c845aed6d385dc947056504b4e22869081b591678c91ed59e39e06f0663" => :high_sierra
    sha256 "be88d595decc9838dc20b04b741076dc5697a0676b6ce6d93114f87709256bac" => :x86_64_linux
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
      system "meson", *std_meson_args, "-Dintrospection=enabled", ".."
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
