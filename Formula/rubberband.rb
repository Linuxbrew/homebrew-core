class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.8.2.tar.bz2"
  sha256 "86bed06b7115b64441d32ae53634fcc0539a50b9b648ef87443f936782f6c3ca"
  revision OS.mac? ? 2 : 4
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "dcfa2c05cc251d0c5e810040646fb5f9511fda2d1cad20ccadce96544a1ad7e3" => :catalina
    sha256 "629837bd83bfcef1003bfb29759d15c29bb7c22740a70f6143bd4c16a5bd3362" => :mojave
    sha256 "f592baa6b5e82c542a92df87789a51b6603e7e8070dfa7f910349a388135b6da" => :high_sierra
    sha256 "73bda45a93508aed54df6986563f97cc8974fb0ea9e17cae9c2385b57cc5f3a5" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"
  on_linux do
    depends_on "ladspa-sdk"
    depends_on "fftw"
    depends_on "vamp-plugin-sdk"
    depends_on "openjdk"
  end

  def install
    unless OS.mac?
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}"
      system "make"
      ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
      system "make", "jni"
      system "make", "install"
    end

    if OS.mac?
      system "make", "-f", "Makefile.osx"
      # HACK: Manual install because "make install" is broken
      # https://github.com/Homebrew/homebrew-core/issues/28660
      bin.install "bin/rubberband"
      lib.install "lib/librubberband.dylib" => "librubberband.2.1.1.dylib"
      lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.2.dylib"
      lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.dylib"
      include.install "rubberband"
    end

    cp "rubberband.pc.in", "rubberband.pc"
    inreplace "rubberband.pc", "%PREFIX%", opt_prefix
    (lib/"pkgconfig").install "rubberband.pc"
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
