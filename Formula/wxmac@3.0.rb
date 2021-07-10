class WxmacAT30 < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS) - Stable Release"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.5.1/wxWidgets-3.0.5.1.tar.bz2"
  sha256 "440f6e73cf5afb2cbf9af10cec8da6cdd3d3998d527598a53db87099524ac807"
  license "wxWindows"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "781881c92fcaadcfea66e7d33a36ae1d9b55d26839738f44248f39d187f46a3c"
    sha256 cellar: :any,                 big_sur:       "42385ebead8045f2f4b1ac40f13f15c18b84b78ffa7110d69ebf8a798cd29dc0"
    sha256 cellar: :any,                 catalina:      "d3d18b83d84b79735bda4497ebd92f763ed7cf4200c8ce8d651070ccd1b2719d"
    sha256 cellar: :any,                 mojave:        "319f6ca3509265ace16fae3aaab777ae932130b741ba51d99702c0391da7833f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01dc105f108e26ceab237d4db8e78f24569edac5e9fc7664b9004939d604ecf" # linuxbrew-core
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--enable-webview",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    on_macos do
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX

    # Move some files out of the way to prevent conflict with `wxmac`
    bin.install "#{bin}/wx-config" => "wx-config-#{version.major_minor}"
    (bin/"wxrc").unlink
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
    Dir.glob(share/"locale/**/*.mo") { |file| add_suffix file, version.major_minor }
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def caveats
    <<~EOS
      To avoid conflicts with the wxmac formula, `wx-config` and `wxrc`
      have been installed as `wx-config-#{version.major_minor}` and `wxrc-#{version.major_minor}`.
    EOS
  end

  test do
    system bin/"wx-config-#{version.major_minor}", "--libs"
  end
end
