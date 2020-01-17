# mongo-c-driver: Build a bottle for Linux
class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.16.0/mongo-c-driver-1.16.0.tar.gz"
  sha256 "a4e7ed92e3a2a28640987507b4b9da18c2ed225fe87af00ea9deec839cdd55e0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "b901eb96048af20c4c24e79b2377a63c3696aaf51f6023282f4e847852029b54" => :catalina
    sha256 "facf3b30374e70fbdef7fb32a85a080ffe3a37dce3e3bd7c5ee8396995e3a586" => :mojave
    sha256 "fa02ae77d194ee72904a010b5d908babc570191f3b7879ef87dcea949ab20903" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  unless OS.mac?
    depends_on "openssl@1.1"
    depends_on "zlib"
  end

  def install
    cmake_args = std_cmake_args
    if build.head?
      cmake_args << "-DBUILD_VERSION=1.17.0-pre"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
