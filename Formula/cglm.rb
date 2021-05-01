class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.1.tar.gz"
  sha256 "33c25e22c0ac00741c8259ad02c369b4aadcecbdf3091bf7eaade4aa996e35bb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "55f7f2b59e6aa0c4461dffb74b2e058649d33785371a3f46352c8c332ce49668"
    sha256 cellar: :any,                 big_sur:       "573a6e6574facd161228dc7eaecee9d18ddf8451748a1913854b1c9fd2d10fe9"
    sha256 cellar: :any,                 catalina:      "fee2fc016362262fd139e6ccfb7fcff3814e03b8c5d1d117ac5d149885b1101d"
    sha256 cellar: :any,                 mojave:        "14e8e9b0e99b29115100a96ef2cbf2539c6a14bfd4d4608eb91b02538603ab61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2a374005feeb46f4cd594d22bea8e3bde8b92fc99dded47863059a013ca520"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
