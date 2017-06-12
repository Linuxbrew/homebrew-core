# fontconfig: Build a bottle for Linuxbrew
class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.3.tar.bz2"
  sha256 "bd24bf6602731a11295c025909d918180e98385625182d3b999fd6f1ab34f8bd"

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    rebuild 1
    sha256 "320647254df248fe051768352f6d671d7cc2347fc5d25a04a7a3c2c93cd7e731" => :sierra
    sha256 "3b52ab43bf9b6685d7a56c91e1792bf2faa701df97db8cb1f5b55a1c392120db" => :el_capitan
    sha256 "7fc0ad1907ed19ce3d2668fd46fc1b41da80b79cfb540c61edbfe5c0a2daa76c" => :yosemite
    sha256 "3f7a8c4091151612839808031179b161685cd3614129f7c2d79dc57eba5c5fb7" => :x86_64_linux
  end

  pour_bottle? do
    default_prefix = BottleSpecification::DEFAULT_PREFIX
    reason "The bottle needs to be installed into #{default_prefix}."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == default_prefix }
  end

  head do
    url "https://anongit.freedesktop.org/git/fontconfig", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix conflicting types for FCObjectTypeHash
  # See https://bugzilla.freedesktop.org/show_bug.cgi?id=101280
  # Both patches are needed
  patch do
    url "https://cgit.freedesktop.org/fontconfig/patch/?id=5c49354a782870d632884174f10c7fb10351c667"
    sha256 "16c2d585a76f6a03d675485e2aadf6471178cbddab0c0f9d8bb9dd3a6141f1e1"
  end

  patch do
    url "https://cgit.freedesktop.org/fontconfig/patch/?id=28139816d62b8444ca61a000a87c71e59fef104d"
    sha256 "5d53356fdf4ac9fa7f72568fbd50b558623de1637b5405c3aca1d5caffe90685"
  end

  keg_only :provided_pre_mountain_lion

  option "without-docs", "Skip building the fontconfig docs"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "expat"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gperf" => :build
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if MacOS.version == :sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font3"
    elsif MacOS.version == :high_sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font4"
    end

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          ("--disable-docs" if build.without? "docs")
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
