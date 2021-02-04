class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.5.1/stella-6.5.1-src.tar.xz"
  sha256 "0348a76e76a5a3feb41aa776a27501fa3c5f51a2159ec06525f4ee8d0e71d414"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "a61b80a329b7cf2a965225bcff5a2a19e8c5432ce727e02de47cf5497cb2c8e8"
    sha256 cellar: :any_skip_relocation, catalina:     "10607ea0a2031f549b367ca28afef8d90228cd143b5e6ac834c0bc2b2518b5db"
    sha256 cellar: :any_skip_relocation, mojave:       "da4689a8d5db9f021ac0a382d00ec144269d63db4b77e1befd2ae087147873ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6151f9084caff5a68c91f689f0852cf0c8e020e5f011450ee2fea0e03775cf4d"
  end

  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  # Stella is using c++14
  unless OS.mac?
    fails_with gcc: "5"
    fails_with gcc: "6"
    fails_with gcc: "7"
    depends_on "gcc@8"
  end

  uses_from_macos "zlib"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} /\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} /\* png)}, '//\1'
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--with-sdl-prefix=#{sdl2.prefix}",
                          "--with-libpng-prefix=#{libpng.prefix}",
                          "--with-zlib-prefix=#{Formula["zlib"].prefix}"
    system "make", "install"
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip if OS.mac?
    # Test is disabled for Linux, as it is failing with:
    # ERROR: Couldn't load settings file
    # ERROR: Couldn't initialize SDL: No available video device
    # ERROR: Couldn't create OSystem
    # ERROR: Couldn't save settings file
  end
end
