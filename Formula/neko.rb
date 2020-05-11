class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  revision 1
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f101a4304c00fef7c7bbe59cc3e13c29bdfd0c8fc6d0675143011157eb3a245b" => :catalina
    sha256 "1e6101a96f295482f8b4c427ddb4aec296bcf4d43e28f7c004a6b8a14aa8658a" => :mojave
    sha256 "2bca5474e29dae508cf5095f695fa8348f8b599233ed299b3c693aa02e7f8087" => :high_sierra
    sha256 "e6b92b6dbb8b5561321781b4f12ba964eb5b94042f1db86eb330946e4e764a3e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"
  unless OS.mac?
    depends_on "apr"
    depends_on "apr-util"
    depends_on "httpd"
    # On mac, neko uses carbon. On Linux it uses gtk2
    depends_on "gtk+"
    depends_on "pango"
    depends_on "sqlite"
  end

  def install
    args = std_cmake_args
    unless OS.mac?
      args << "-DAPR_LIBRARY=#{Formula["apr"].libexec}/lib"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].libexec}/include/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].libexec}/lib"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].libexec}/include/apr-1"
    end
    inreplace "libs/mysql/CMakeLists.txt",
              %r{https://downloads.mariadb.org/f/},
              "https://downloads.mariadb.com/Connectors/c/"

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
