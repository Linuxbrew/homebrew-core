class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.14.tar.gz"
  sha256 "d8215b571a581be1332d2106f8036fcb03d12a70bae01e20f424976d275432bc"
  license "Zlib"
  revision 1

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/SDL2[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2ae70b6025c4e241400643f2686c8e288d50e3f04311e63d8a1f8180ed4afb07"
    sha256 cellar: :any, big_sur:       "ccde7145d4334d9274f9588e6b841bf3749729682e1d25f590bdcf7994dfdd89"
    sha256 cellar: :any, catalina:      "d6ae3300160c5bb495b78a5c5c0fc995f9e797e9cdd4b04ef77d59d45d2d694d"
    sha256 cellar: :any, mojave:        "4f3988fb3af0f370bc1648d6eb1d6573fd37381df0f3b9ee0874a49d6a7dec2e"
    sha256 cellar: :any, x86_64_linux:  "feb0cb7f4d5338f820892d917e821cfe09ad4ca0b66c5981b9af06411c199f09"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  unless OS.mac?
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "xinput"
    depends_on "pulseaudio"
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = if OS.mac?
      %W[--prefix=#{prefix} --without-x]
    else
      %W[--prefix=#{prefix} --with-x]
    end

    args << "--enable-hidapi"

    unless OS.mac?
      args += %w[
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
      ]
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
