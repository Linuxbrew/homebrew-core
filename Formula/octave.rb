class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-6.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-6.1.0.tar.xz"
  sha256 "d6cd6b79ef023e300b9287b56aa79333cfb6b651771d43ade7cbde63ca5a6010"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_big_sur: "8f06de8a81e26a256997ab63f293a0cf7a45d2aa903bec5fad64f0eeac4dff91"
    sha256 big_sur:       "ff33dcad0c4ac9f3217536737c0efa63502c6fe918fbe188d44dfce82f3eb4a3"
    sha256 catalina:      "ea27285a96cdfa71144297ee0d63e1a26df618b8f763a40994d62bc91aca2d41"
    sha256 mojave:        "45e1d85154018d876e772283c5efe297383355b9be5aa287c51fe583b5d9b9d9"
    sha256 x86_64_linux:  "4a92d3377d59e4e7f22a342f19991c605871a540cb0ae36fc2c6711e9bff0eb3"
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", branch: "default", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fig2dev"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "ghostscript"
  depends_on "gl2ps"
  depends_on "glpk"
  depends_on "gnuplot"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "openblas"
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "qscintilla2"
  depends_on "qt"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"

  uses_from_macos "curl"

  on_linux do
    depends_on "autoconf"
    depends_on "automake"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-link-all-dependencies",
            "--enable-shared",
            "--disable-static",
            "--disable-docs",
            "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
            "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
            "--with-java-homedir=#{Formula["openjdk"].opt_prefix}",
            "--with-x=no",
            "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
            "--with-portaudio",
            "--with-sndfile"]

    unless OS.mac?
      # Explicitly specify aclocal and automake without versions
      args << "ACLOCAL=aclocal"
      args << "AUTOMAKE=automake"

      # Mesa OpenGL location must be supplied by LDFLAGS on Linux
      args << "LDFLAGS=-L#{Formula["mesa"].opt_lib} -L#{Formula["mesa-glu"].opt_lib}"

      # Need to regenerate aclocal.m4 so that it will work with brewed automake
      system "aclocal"
    end

    system "./configure", *args
    system "make", "all"

    # Avoid revision bumps whenever fftw's, gcc's or OpenBLAS' Cellar paths change
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath/"scripts/startup/site-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{Formula["texinfo"].opt_bin}/makeinfo\");"

    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with BLAS
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
