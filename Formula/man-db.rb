class ManDb < Formula
  desc "Unix documentation system"
  homepage "http://man-db.nongnu.org/"
  url "http://download.savannah.gnu.org/releases/man-db/man-db-2.7.6.1.tar.xz"
  sha256 "08edbc52f24aca3eebac429b5444efd48b9b90b9b84ca0ed5507e5c13ed10f3f"
  # tag "linuxbrew"

  head do
    url "git://git.sv.gnu.org/man-db.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    sha256 "3fa618e0db198499a32a305241e59dd31eb513ff5dedaf693fb674cb8b6612a4" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libpipeline"
  unless OS.mac?
    depends_on "gdbm"
    depends_on "groff"
    depends_on "zlib"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/man", "--version"
  end
end
