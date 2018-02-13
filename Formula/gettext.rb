class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
  sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"
  revision 1 unless OS.mac?

  bottle do
    sha256 "99d2dbd4c9ebfe9bf2a64bd99f3a695a18635f0d9110eaff34bab8022abef6a8" => :high_sierra
    sha256 "8368522242c5fe33acd5c80b5f1321559da9efe20878da6e4b9507683a740c21" => :sierra
    sha256 "311475f36f3fd314ae0db4fb52e4ab769f62ded6c8c81678ad8295f41762e4ba" => :el_capitan
    sha256 "ca8fe572e7c8db00bb1bdfd66c379ba4a960927f4b829f47f9e2335c51dc7376" => :yosemite
    sha256 "e3091192716347fc54f6e8a8184d892feed5309672daa061a1407b071af80c05" => :mavericks
  end

  keg_only :shadowed_by_macos,
    "macOS provides the BSD gettext library & some software gets confused if both are in the library path"

  # https://savannah.gnu.org/bugs/index.php?46844
  depends_on "libxml2" if MacOS.version <= :mountain_lion && OS.mac?

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib" # for libxml2
    # libxml2 is vendored here to break a cyclic dependency:
    # python -> tcl-tk -> xorg -> libxpm -> gettext -> libxml2 -> python
    resource("libxml2") do
      url "http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"
      mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.7.tar.gz"
      sha256 "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c"
    end
  end

  def install
    resource("libxml2").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}",
                            "--without-python",
                            "--without-lzma"
      system "make", "install"
    end unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          ("--with-included-gettext" if OS.mac?),
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--with-lispdir=#{elisp}",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs",
                          "--without-xz",
                          ("--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}" if OS.mac?)
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
