class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.5.0.tar.gz"
  sha256 "50f7a3e3aec2e08e732a487919262238f8504c3ef927246ec3495617dde81239"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "96272ee3928cc30b8814aca520809b65fb94830d63ddaec928957ab0daaca330" => :sierra
    sha256 "7311ad6d0936cd828e65fa7e27c189fa375c19538620c8252e06c813bb144435" => :el_capitan
    sha256 "bd7aee67c923392a0038673e3f8c361a3bfec169b5ab03cb6cbb30f56c330d35" => :yosemite
    sha256 "61be2a13d8c4636f33a9ac8f90f48e768ecc37901290b0373462ca753fcefeed" => :x86_64_linux # glibc 2.19
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :fortran
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :mpi => [:optional, :f77]

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec} ]
    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif build.with? "veclibfort"
      args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      args << "--with-blas=-lblas -llapack"
    end

    args << "F77=#{ENV["MPIF77"]}" << "--enable-mpi" if build.with? "mpi"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"

    if build.with? "mpi"
      (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
    end
  end

  test do
    ENV.fortran
    opts = %W[-L#{opt_lib} -larpack]
    if Tab.for_name("arpack").with? "openblas"
      opts << "-L#{Formula["openblas"].opt_lib}" << "-lopenblas"
    elsif OS.mac?
      opts << "-L#{Formula["veclibfort"].opt_lib}" << "-lvecLibFort"
    else
      opts << "-lblas" << "-llapack"
    end
    system ENV.fc, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f", *opts
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")

    if build.with? "mpi"
      cp_r (libexec/"bin").children, testpath
      %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
         psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
        system "mpirun", "-np", "4", slv
      end
    end
  end
end
