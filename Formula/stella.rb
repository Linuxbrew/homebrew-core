class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.0.1/stella-6.0.1-src.tar.xz"
  sha256 "d611f98bb35ed9eacfb63826b12b4e8b67b874a2a87019d4bdaf1e7f4724c40d"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "9356bf82472ace4d0c9fe325fba4239ff990cb7ae89ca47090512d79a07619b1" => :mojave
    sha256 "c8218d2bdb301dd5f4268c4b7fc16e88676740d69106b76729955ccd18a795da" => :high_sierra
    sha256 "68d9cc4bb6dd3ff15efb113824546c03c55c856927ba4fff9b36ec18246b820f" => :sierra
  end

  depends_on :xcode => :build if OS.mac?
  depends_on "libpng"
  depends_on "sdl2"
  uses_from_macos "zlib"
  # Stella is using c++14
  fails_with :gcc => "4.8" unless OS.mac?

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    if OS.mac?
      cd "src/macos" do
        inreplace "stella.xcodeproj/project.pbxproj" do |s|
          s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
          s.gsub! %r{(\w{24} \/\* png)}, '//\1'
          s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                  "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
          s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                  "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
          s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
        end
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
