class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/5.0.2/stella-5.0.2-src.tar.xz"
  sha256 "74ee708b68340b65519a04a22c61921cdcf69a1d308600c212414b28e9e689ac"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "a5f27dadb73bac03b216c87bec7e4de593aadfdeaa6e1058d0a5c457d16a1071" => :sierra
    sha256 "443b004f1f0cf445b66a28a253a423f2f02ca32729a828ff2fb0ccc414a914f4" => :el_capitan
    sha256 "1f53b58fc29ced3dd2390191760481af1ecdf822653ff02b2e5a0ce5420f4ace" => :yosemite
    sha256 "ad5e4f05da98c92f6126a59085b6a459c41de8dc5b23ff971639e9b90aed1541" => :x86_64_linux # glibc 2.19
  end

  needs :cxx14

  depends_on :xcode => :build if OS.mac?
  depends_on "sdl2"
  depends_on "libpng"
  depends_on "zlib" unless OS.mac?
  # Stella is using c++14
  fails_with :gcc => "4.8" unless OS.mac?

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    if OS.mac?
      cd "src/macosx" do
        inreplace "stella.xcodeproj/project.pbxproj" do |s|
          s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
          s.gsub! %r{(\w{24} \/\* png)}, '//\1'
          s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                  "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
          s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                  "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
          s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
        end
        xcodebuild "SYMROOT=build"
        prefix.install "build/Release/Stella.app"
        bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
      end
    else
      system "./configure", "--prefix=#{prefix}",
                            "--bindir=#{bin}",
                            "--with-sdl-prefix=#{sdl2.prefix}",
                            "--with-libpng-prefix=#{libpng.prefix}",
                            "--with-zlib-prefix=#{Formula["zlib"].prefix}"
      system "make", "install"
    end
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
