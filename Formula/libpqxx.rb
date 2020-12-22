class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.3.0.tar.gz"
  sha256 "55563821727310828cd79737732ca7e14a49dbbaa86bdce7c5829d440dafde59"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d1677be98c31ac3533053137ca68a9a99be1221e797305a26617cc9d797e5b9d" => :big_sur
    sha256 "56f976bd0211daafbb869d2f53aa368999812dec72eecfee43178cd71c95c295" => :arm64_big_sur
    sha256 "53ed6045a272a0369d445a23508cbda5f01ef4018ef72d63740e5b0d05885bcb" => :catalina
    sha256 "c9a15d608af5d566d0a790d9460f12b9a0589b193302f99a29e568aaca7a007e" => :mojave
    sha256 "5d647a3aaee8b610fa7367429faa258a807522ee609208eb8f61f90492e827dc" => :x86_64_linux
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
