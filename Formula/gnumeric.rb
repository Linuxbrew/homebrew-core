class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.47.tar.xz"
  sha256 "40159f34128a13c6102a512c01cdb050a779801072e55b16f2a0e038c57119ce"

  bottle do
    sha256 "04e56643897cfc7699f16dcf0cdb5bd48783eb8ccbcc8b12dd5ebb1af445b5d7" => :catalina
    sha256 "666fafcd212cf2ed17c714b616b0828fdcd5608eaec5611dd5256375da9c5320" => :mojave
    sha256 "dab647cf3378e1b5a3a7e24abb427190994dd5d19b6b5b8c499f8bd4e065d1bd" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "goffice"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "rarian"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
