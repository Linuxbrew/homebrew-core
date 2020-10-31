class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.3/stella-6.3-src.tar.xz"
  sha256 "59ee35a3e49f52e64fa15e0217ecda90ccb768dcb075d997e72d5e5a3198f82e"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "bf868761209511cc1c31233f22f6c7bd95d7f2ce4045f83057b8b2209f2231d9" => :catalina
    sha256 "c3622486edcba6a4d31cb2945411fb69ec2dc04cfde529f30537965e566318a2" => :mojave
    sha256 "2034af90fcc6aba5af2e5d6718ec99309b55a3dbc415f32017f8d2e0a1b72a70" => :high_sierra
    sha256 "448ff159b62676a4f5c9679479f7e079593a1d32945cd0e903a44f3d9654d605" => :x86_64_linux
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
