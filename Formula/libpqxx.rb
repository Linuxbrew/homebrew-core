class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.3.1.tar.gz"
  sha256 "c794e7e5c4f1ef078463ecafe747a6508a0272d83b32a8cdcfb84bb37218a78b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8a331a7d9b847c409e959afdf7ca19eea8ed294b6a511fc6f11a8a2af09adb28"
    sha256 cellar: :any, big_sur:       "31966e7684f2d14bbce813826ac6a8fd32fa7a5994eb42e288a06dd9644f64a1"
    sha256 cellar: :any, catalina:      "e326cc5eaced4f2499f8cfc53d807070a57a6ff6e166ae3712794c96688bed74"
    sha256 cellar: :any, mojave:        "c9cb4e5f9ee9d134d55a2fe6d8384b29765c9a301356aef096fa967136bac6bf"
    sha256 cellar: :any, x86_64_linux:  "9906f245253911e5c711cbae29208595ac005a519cdd62ea8090223b9acbd42e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on "postgresql"

  unless OS.mac?
    depends_on "doxygen" => :build
    depends_on "xmlto" => :build
    depends_on "gcc@9"
    fails_with gcc: "5"
    fails_with gcc: "6"
    fails_with gcc: "7"
    fails_with gcc: "8"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    cxx = OS.mac? ? ENV.cxx : Formula["gcc@9"].opt_bin/"g++-9"

    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
