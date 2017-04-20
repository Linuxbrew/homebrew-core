# http-parser: Build a bottle for Linuxbrew
class HttpParser < Formula
  desc "HTTP request/response parser for c"
  homepage "https://github.com/nodejs/http-parser"
  url "https://github.com/nodejs/http-parser/archive/v2.7.1.tar.gz"
  sha256 "70409ad324e5de2da6a0f39e859e566d497c1ff0a249c0c38a5012df91b386b3"

  bottle do
    cellar :any
    sha256 "a19519cd90917dccb31171febe7e25baaa583ec9bdd7c4e4d06dcb2a7605447f" => :sierra
    sha256 "afc0af78e3a4789b18b96ec83a09a38c5e6fc0f6ba72523a1f5c0f4b4d1441e6" => :el_capitan
    sha256 "0d62dc8723a72e60d13fbd61f870a8e3cc3a7f29fc5814c645322c284be7514c" => :yosemite
    sha256 "5d3aaf70d3ca4ee5ff688b9f834acd68891d4fb637721b54597deeba6fca41d0" => :mavericks
    sha256 "45832baced3b0e74c35748a9e9a0c8a8a8fae9ecc6e2c5bacaf3e3f83d509a0f" => :x86_64_linux
  end

  depends_on "coreutils" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "INSTALL=ginstall"
    pkgshare.install "test.c"
  end

  test do
    # Set HTTP_PARSER_STRICT=0 to bypass "tab in URL" test on macOS
    system ENV.cc, pkgshare/"test.c", "-o", "test", "-L#{lib}", "-lhttp_parser",
           "-DHTTP_PARSER_STRICT=0"
    system "./test"
  end
end
