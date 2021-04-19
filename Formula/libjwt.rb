class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.13.0.tar.gz"
  sha256 "82b0412499f2f838ccf7b2ae26f00e90f081a4b0a56c4278d5eb0185b1334395"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "933563d341e01adcc81503b3b3d043b834310bf69973c31f495fb58f5ec4e725"
    sha256 cellar: :any, big_sur:       "c32d81541ca6483a85f49777d6a4e54eb8bdb4318aae54c8f3a5c615003977de"
    sha256 cellar: :any, catalina:      "05956fd035389488a5c37d6512ecbf0576cf8bcf54c6270769ce37268e6ecea6"
    sha256 cellar: :any, mojave:        "a1a41e5c06932d420c32ec962555fd14bc0a2331ad9633413f3d5df452e8a259"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-I#{include}", "test.c", "-ljwt", "-o", "test"
    system "./test"
  end
end
