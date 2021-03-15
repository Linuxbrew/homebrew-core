class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.0.tar.gz"
  sha256 "35b0f4bac3d17fef47e28611dbeb51e07639395e957f23f4a3cc60770db1ab9c"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "e60d94c96a1f877a589541e417b7dfb05ffb25c07360a00b8d04787a55661b26"
    sha256 cellar: :any,                 catalina:     "aa9d2e9a4e192c1616e83a59b190938806a5b2ad976370ade86e060bb55d834c"
    sha256 cellar: :any,                 mojave:       "24526301bf8168625de7688cc8ccad8a420be76b4b9395349f77e39495c72788"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1643e9106476d708f692bf6a54772dd35d05a2412d5f81df2563f7839d8759f9"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cassandra.h>

      int main(int argc, char* argv[]) {
        CassCluster* cluster = cass_cluster_new();
        CassSession* session = cass_session_new();

        CassFuture* future = cass_session_connect(session, cluster);

        // Because we haven't set any contact points, this connection
        // should fail even if a server is running locally
        CassError error = cass_future_error_code(future);
        if (error != CASS_OK) {
          printf("connection failed");
        }

        cass_future_free(future);

        cass_session_free(session);
        cass_cluster_free(cluster);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output("./test")
  end
end
