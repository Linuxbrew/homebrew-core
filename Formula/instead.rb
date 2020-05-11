class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"

  bottle do
    sha256 "e447bee8716c692d07e6d58b337639a64334dfa921326810c5ae0d64b14fe72e" => :catalina
    sha256 "128a389655c4361f48dd8ee81344682a3d4433485cf91569a71961bed0885e06" => :mojave
    sha256 "e9029b89e6133d0f233a679a684e64d0195b283aabb6c55640f8a95ed1297f50" => :high_sierra
    sha256 "0a6913b90f9c3d01b83d37cc3f467470c5e9982c5bffd9a7076ab6287aa44157" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    libext = if OS.mac?
      "dylib"
    else
      "so"
    end

    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua",
                            "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.#{libext}",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
