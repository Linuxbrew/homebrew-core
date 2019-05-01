class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-215.tar.bz2"
  sha256 "5a01135e0315879abca0fcfe74bdc4949d8284e9c31b1e8ea4ddbf9e63a9985a"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "d9879aab4e7ce800b09978690a8cf6e820ac874f3ffbd471716b7e3ce7926c30" => :mojave
    sha256 "c0b16efd0c98e3557a5c1b4c0ebd5bfbfe448a4462265a10e6b875c256e3a6eb" => :high_sierra
    sha256 "a194b3a1758154eb6fac28ce71bd54624a748cae8d9ea3683cd727241924377b" => :sierra
    sha256 "a6e8dd0569ca2a5607da6917adb022cc2340d7488179a04a21f70b61d53e1e80" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
