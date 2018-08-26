class Libuuid < Formula
  desc "Portable UUID C library"
  homepage "https://sourceforge.net/projects/libuuid/"
  # tag "linuxbrew"

  url "https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
  sha256 "46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644"

  bottle do
    cellar :any_skip_relocation
    sha256 "741229726c8670871dde15ceaf099998c1b616e48e64ba035e1f78e72eb37137" => :x86_64_linux # glibc 2.19
  end

  conflicts_with "util-linux", :because => "both install lib/libuuid.a"
  conflicts_with "ossp-uuid", :because => "both install lib/libuuid.a"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uuid/uuid.h>
      int main () {
        uuid_t obj1, obj2, obj3, obj4;
        uuid_generate(obj1);
        uuid_generate_random(obj2);
        uuid_generate_time(obj3);
        if (uuid_generate_time_safe(obj4) != 0)
            return 1;
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-luuid", "-o", "test"
    system "./test"
  end
end
