class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.14.0.tar.gz"
  sha256 "042f965e182b80693015839a9d0278ae73fae5d5d09d8bf6d0e6a39a8c4393bd"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "e19f4ea25971bd484ecbcf1bfd6a1556cf99dff7619f4312cef0fb1caf5b656a" => :catalina
    sha256 "b4ad73060273cc312df323beb4657426ed554b6fa436381e68c5b37fc64dd471" => :mojave
    sha256 "f4ac0116806f6a754175e1ceadca0ddafaf1d70fdd5bc0af0604cb82483040e3" => :high_sierra
    sha256 "df1316285bbf8325a8e9dcc2f8cd472905354cba2b1562cf0dd75e268b596f5c" => :sierra
    sha256 "2c7de23a0b14eddced9c7ce83fc6259288cffa3f580e86b1f15888e68d2267e2" => :x86_64_linux
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}" if OS.mac?

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}",
           pkgshare/"examples/example.c", "-o", testpath/"test", "-lhiredis"
    assert_predicate testpath/"test", :exist?
  end
end
