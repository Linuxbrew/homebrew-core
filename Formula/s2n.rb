class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "b65a3e01494422c3ecbbc51da087184ee80cd7159a54cf85ba3b8879e0b56bb8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1f0d2703678434995382e4d9340fe13f6d6e4b9bf2cb4774438f496f387e6c4b"
    sha256 cellar: :any, big_sur:       "07a768d3d737e9068bef4a91ab1c395c045e23b6bda755077ca28c266c93fd04"
    sha256 cellar: :any, catalina:      "a822c61343abe4ea09374052e0dddefda31ecb44a79804cfa8e39aad5778eb1f"
    sha256 cellar: :any, mojave:        "4fe3142ee8c30f8a03a4705c9a1267494f09988b17625e940264ee45928e20ec"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    system "./test"
  end
end
