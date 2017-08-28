class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.20.tar.gz"
  sha256 "6c0d87c94ab9915e76ecd313baec08dedf3bd56de83743d9aa923a081935d2f5"

  bottle do
    cellar :any
    sha256 "d6ed7a2c17bce7c8d6e96530ebe7cfabbf814e701c301d824b11ea22cd46d7d0" => :sierra
    sha256 "782f20517ff7f10a76a5969eb698c9fd9fc279459c56cfb90dda81c30ec5b5ce" => :el_capitan
    sha256 "07bfd3dd2f19032d05d2415642569df0ec8a74f48f545b3e5e1a8548849e9b42" => :yosemite
    sha256 "8aa860a155529e4e659572b06b442fd90551580773a283f93070af18e0efed39" => :x86_64_linux # glibc 2.19
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "glib" => :build unless OS.mac?
  depends_on "ncurses" unless OS.mac?

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
