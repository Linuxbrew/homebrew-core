class Netpbm < Formula
  desc "Image manipulation"
  homepage "https://netpbm.sourceforge.io/"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  if OS.mac?
    url "https://svn.code.sf.net/p/netpbm/code/stable", :revision => 3712
  else
    url "https://sourceforge.net/code-snapshots/svn/n/ne/netpbm/code/netpbm-code-r3712-trunk.zip"
    sha256 "e96662ea30d2704c8b22f34e67e898c5e956855bccfb323b9f74bb08f1dadf8d"
  end
  version "10.86.07"
  version_scheme 1
  head "https://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "6640bdd9642b8dc0920678a2c85cbd5741e72fe81a097d63110fc667b1dacf79" => :catalina
    sha256 "f537e20d981cc3aba9f53cadee4cb65231844395cf6fde7d737a6c8e8b010f48" => :mojave
    sha256 "5d5a95822446eb6a95a945a03c555d6dea969ae57f2b1e08811f7d3f4e8b95e8" => :high_sierra
  end

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "flex" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  conflicts_with "jbigkit", :because => "both install `pbm.5` and `pgm.5` files"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      if OS.linux?
        s.change_make_var! "CFLAGS_SHLIB", "-fPIC"
      elsif OS.mac?
        s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
        s.change_make_var! "NETPBMLIBTYPE", "dylib"
        s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
        s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      end
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir["man/man1/*.1"]
      man5.install Dir["man/man5/*.5"]
      lib.install Dir["staticlink/*.a"]
      lib.install Dir["sharedlink/*.dylib"] if OS.mac?
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end
  end

  test do
    fwrite = Utils.popen_read("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system "#{bin}/pamdice", "test.pam", "-outstem", testpath/"testing"
    assert_predicate testpath/"testing_0_0.", :exist?
  end
end
