class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.33.2",
      revision: "ee5b762f33a42170144834f5ab7efda9d76c480b",
      shallow:  false
  license "Apache-2.0"
  revision 2
  head "https://github.com/grpc/grpc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "3e731c3e9d4c6d24f5293db3b93efc0d277f12f03679b6f35af9e0cea67e613c" => :big_sur
    sha256 "56d08703d69bc715c72b93a28c848ddaac63f1c2fbad09ebf39b271ff658fe8a" => :catalina
    sha256 "71b413ceeae0da5f236ef71fe9ea5168849df37462ba70a2ac9d99e1f5bf18c5" => :mojave
    sha256 "05cfa98fcf89ed4ce8bdc12254a926656ccdba4490fee22ca2e7f391844537f1" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@6" => :build
  end

  def install
    mkdir "cmake/build" do
      args = %w[
        ../..
        -DCMAKE_CXX_STANDARD=17
        -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=OFF
        -DgRPC_INSTALL=ON
        -DgRPC_ABSL_PROVIDER=package
        -DgRPC_CARES_PROVIDER=package
        -DgRPC_PROTOBUF_PROVIDER=package
        -DgRPC_SSL_PROVIDER=package
        -DgRPC_ZLIB_PROVIDER=package
        -DgRPC_RE2_PROVIDER=package
      ] + std_cmake_args

      system "cmake", *args
      system "make", "install"

      args = %w[
        ../..
        -DCMAKE_EXE_LINKER_FLAGS=-lgflags
        -DCMAKE_SHARED_LINKER_FLAGS=-lgflags
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=ON
        -DgRPC_GFLAGS_PROVIDER=package
      ] + std_cmake_args

      system "cmake", *args
      system "make", "grpc_cli"
      bin.install "grpc_cli"
      lib.install Dir["libgrpc++_test_config*.{dylib,so}.*"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
