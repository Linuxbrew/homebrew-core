class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.4.2.tar.gz"
  sha256 "3b99a36c082a67ef6295eabd4fb3e32ab0bff7c6b0d397d6352697335f4e57eb"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "aeb65f3ab7698df3558d34f6d7b48afd74443038bcfb88241ca0859d7094061a" => :catalina
    sha256 "0016c630e88d215dbca89598f95c86ab9cafb4b697164c41f52c122f4ec4000c" => :mojave
    sha256 "31d79c743190d68310911756175d7dc9637c5cad567519f84021ca8349583cf8" => :high_sierra
    sha256 "8f0d9b72ee9145f9ef2783d27e602c4602a961a4fda2373b2f6166c1fb3a95ee" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  depends_on "python" unless OS.mac?

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
