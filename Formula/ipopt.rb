class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.13.4.tar.gz"
  sha256 "1fdd0f8ea637856d66b1ebdd7d52ad1b8b8c1142d1a4ce0976b200ab280e5683"
  license "EPL-1.0"
  revision 1 unless OS.mac?
  head "https://github.com/coin-or/Ipopt.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "c63686d9c36309fc55f88e7d9a97b99e34d20ccabd68e66009fdaab1e7ea4f6c"
    sha256 cellar: :any,                 catalina:     "9e14aaecd0e58c1047ea13327314a99f30dd0fbc2049af6681aa879f8dccd617"
    sha256 cellar: :any,                 mojave:       "ed286516c3ae473b824b5cefa4186e1519aa371464ec80f8c949a9da3eb50475"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e65904a70b0d82eda5176192d3fc2499753e030143cb35cdd67dfa809bd5b66b"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    url "http://mumps.enseeiht.fr/MUMPS_5.3.5.tar.gz"
    sha256 "e5d665fdb7043043f0799ae3dbe3b37e5b200d1ab7a6f7b2a4e463fd89507fa4"

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
    url "https://github.com/coin-or/Ipopt/archive/releases/3.13.4.tar.gz"
    sha256 "1fdd0f8ea637856d66b1ebdd7d52ad1b8b8c1142d1a4ce0976b200ab280e5683"
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
