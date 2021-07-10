class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  license "BSD-3-Clause"
  revision OS.mac? ? 1 : 2
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  stable do
    url "https://github.com/xianyi/OpenBLAS/archive/v0.3.15.tar.gz"
    sha256 "30a99dec977594b387a17f49904523e6bc8dd88bd247266e83485803759e4bbe"

    # Fix compile on ARM
    # https://github.com/xianyi/OpenBLAS/issues/3222
    patch do
      url "https://github.com/xianyi/OpenBLAS/commit/c90c23e78f24f37c6be877e37075463a4ba8f201.patch?full_index=1"
      sha256 "eb89ce6160fc896eb6668658c2e6fdc34942b5e39ed45d28af4673435a500cf5"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "b31f9c8f4548ed99e457e5a022d16e70f3b890797bc8c00142f67f6f3f879327"
    sha256 cellar: :any,                 big_sur:       "7fcddea45a233d6b8dcb14191acdb1ae9d141f7b90d7c26c506490c15bf3396f"
    sha256 cellar: :any,                 catalina:      "1cebbd37f62b6089124eeefa019414e421f9191b9a1941765600834974c22945"
    sha256 cellar: :any,                 mojave:        "a7637fc404144f939928f690fe569530a6fa72373748121cb2a990addc9a6721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c4b29ecdc412ba1eeb5b027a3c7be4adb6d8db24b21f8c24e64971d86707f2" # linuxbrew-core
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc" # for gfortran
  fails_with :clang

  def install
    ENV.runtime_cpu_detection
    ENV.deparallelize # build is parallel by default, but setting -j confuses it

    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran", "libs", "netlib", "shared", *("NO_AVX512=1" unless OS.mac?)
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end
