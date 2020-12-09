class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.2.tar.gz"
  sha256 "bdb827f36e693dc7b443e69d4678d24f1ccc20dc093c22f58b8d78192da15f2e"
  license "MIT"
  revision 1

  bottle do
    sha256 "71af1e349e6da503d572dbe2b0cd969a33020fa9101bbe9692c56c85e02e676c" => :big_sur
    sha256 "a2f65af64781e9b45d363bdf589ab614286cf5342d585699527f63af6cf5d008" => :catalina
    sha256 "d3fb0b0cb48c58ee904d783df541cd71eac200a58ba9a4e9e7a8bffe7c9800b1" => :mojave
    sha256 "9e7f5231f4c41aa1ef393b8ba64509a778cf1eb7cc7c0ab7824523186be469ca" => :x86_64_linux
  end

  depends_on "cmake" => :build

  # Possible patch for lua 5.4 support:
  # https://github.com/instead-hub/instead/commit/ea4f0e81c6859b0aadde582f47ffd7850f54a264
  # Alternatively, this dependency may be replaced with luajit, which is the
  # package's preferred version of lua:
  # https://github.com/instead-hub/instead/blob/master/INSTALL
  depends_on "lua@5.3"

  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    # Make sure I point to the correct lua version!
    lua = Formula["lua@5.3"]

    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DLUA_INCLUDE_DIR=#{lua.opt_include}/lua",
                            "-DLUA_LIBRARY=#{lua.opt_lib}/#{shared_library("liblua")}",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
