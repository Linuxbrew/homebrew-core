class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.14.1.tar.gz"
  sha256 "afa37bbb0d91003c58284113717dc304718a1f236c97fe097dfab1672cb879c6"
  license "EPL-1.0"
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dd6168dd885e5c86595dc4d44418672770d31d63f59dd2dc99d503bf89b94b08"
    sha256 cellar: :any,                 big_sur:       "3effb180e71de5b365670b7f80b4e7a8af7d126f236744c2a09c4954368a05a9"
    sha256 cellar: :any,                 catalina:      "60d8be3bd1f46bfc365a9824c73317719d969193106fd2111dea3c31ff1acfd5"
    sha256 cellar: :any,                 mojave:        "9ad773e484d983e1c9f092f07d5e90491779336edf4a940520ad5c0645410b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ac0887dc0a3b0d7c6f6fbbd1279deedbfa3ac08f389415a269712a64e66e72" # linuxbrew-core
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.4.0.tar.gz"
    sha256 "c613414683e462da7c152c131cebf34f937e79b30571424060dd673368bbf627"

    if OS.mac?
      # MUMPS does not provide a Makefile.inc customized for macOS.
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end
    else
      patch do
        url "https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
      end
    end
  end

  resource "test" do
    url "https://github.com/coin-or/Ipopt/archive/releases/3.14.1.tar.gz"
    sha256 "afa37bbb0d91003c58284113717dc304718a1f236c97fe097dfab1672cb879c6"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/" if OS.mac?

      inreplace "Makefile.inc", "OPTF    = -fPIC",
                "OPTF    = -fPIC -fallow-argument-mismatch"

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir[
        "lib/#{shared_library("*")}",
        "libseq/#{shared_library("*")}",
        "PORD/lib/#{shared_library("*")}"
      ]
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-mp"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-mp"].opt_lib} -lasl",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkg_config_flags = `pkg-config --cflags --libs ipopt`.chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkg_config_flags
    system "./a.out"
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb"
  end
end
