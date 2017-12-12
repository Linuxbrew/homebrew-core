class MfxDispatch < Formula
  desc "Intel media sdk dispatcher"
  homepage "https://github.com/lu-zero/mfx_dispatch"
  url "https://github.com/lu-zero/mfx_dispatch/archive/1.23.tar.gz"
  sha256 "d84db51a9d3ec6b5282fc681fba6b2c721814a6154cfc35feb422903a8d4384b"
  
  head do
    url "https://github.com/lu-zero/mfx_dispatch.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  
  depends_on "linuxbrew/xorg/libva"
  depends_on "linuxbrew/xorg/libdrm" => :recomended
  depends_on "linuxbrew/xorg/libx11" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --disable-examples
      --with-libva_drm=#{build.with?("libdrm") ? "yes" : "no"}
      --with-libva_x11=#{build.with?("libx11") ? "yes" : "no"}
    ]
    
    system "autoreconf", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    # Not quite sure how to test it, it should install a .pc file for headers, and make the libraries available
    # Someone could help out with this bit.
    system "true"
  end
end
