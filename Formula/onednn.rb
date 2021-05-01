class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "01e651eb20ca1943bbdf756804fd02d13e5ff3c84b89e3aa5d40abdeb5bb07ee"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c752d71b52a5f34f3e2cab905ccad23c0c3fe17bf5332c0c23f5b2f89e48aea8"
    sha256 cellar: :any,                 big_sur:       "ab423e04dee0d881e5351006ad210a578e576507ffe19a1d268947a30cdc28b4"
    sha256 cellar: :any,                 catalina:      "d3c2fa62d404e4eacba87d1c55ab750298aed7a1cf54350a88527026170299bb"
    sha256 cellar: :any,                 mojave:        "3051bced3721a7fc3b12db277d7c295713aa028a689f56a7716b5b081451e9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddd1b47b01252a57f0913d6bbe9665861ba58be6dc953f0955215fc0fc86512"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
