# arpack: Build a bottle for Linuxbrew
class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.5.0.tar.gz"
  sha256 "50f7a3e3aec2e08e732a487919262238f8504c3ef927246ec3495617dde81239"
  revision 1
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "79916ca5fe573b2a4394cfdef2ef29c7a7070728ea9d0001fc1b565d30de94e0" => :high_sierra
    sha256 "cd4f84697d2e170fe14b9be297b1f95282b4f0c5631c2a89240e31a64b06c516" => :sierra
    sha256 "a3fff906ab6a5da67d6e5b770818416d5c609efb217211e77b227895603f7ee3" => :el_capitan
  end

  option "with-mpi", "Enable parallel support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for gfortran
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "openblas" unless OS.mac?

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec} ]
    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif build.with? "veclibfort"
      args << "--with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort"
    else
      args << "--with-blas=-lblas -llapack"
    end

    args << "F77=mpif77" << "--enable-mpi" if build.with? "mpi"

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
