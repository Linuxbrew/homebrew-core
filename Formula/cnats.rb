class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.5.1.tar.gz"
  sha256 "1d8dce8ff44da9631639c18a0a6a2e9eef1e76da0fef5a45aa8f56150f9e0246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f6a726551e6b0efd9481ca859103457f0d6ef57260b9d098370f2f14e56f14a8"
    sha256 cellar: :any,                 big_sur:       "de8a54edf9b46eba3b4573e4dfc6e0c1d4b1fbd20e5bd1ab43a5d7661801c6e7"
    sha256 cellar: :any,                 catalina:      "8a64690fe7df0f15c1f6622659b985443e7bc496340cbeeb974e225ba3d04ae1"
    sha256 cellar: :any,                 mojave:        "1dd30e7acb8b7cae563bf5e8e79745deac2ef63c79b840d791d7ac1dd5249d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa51e30abaf6976d1cbace6c58df009876267a655ecfb146de4999891d822be" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
