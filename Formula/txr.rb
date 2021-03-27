class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-255.tar.bz2"
  sha256 "5e5a7929c5b3c787ad85a28b94a97b6f5666fc6f9f5a062c77ce3812320eb59c"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "5d4728954cc7d47be9e88402be6976144219cf4b1c8afd4965915fcc6c45e66a"
    sha256 cellar: :any, catalina: "fd265f6c99c13a363b12f3ca857cdc60ee2c079eca20cb29f62ba9b985db78cd"
    sha256 cellar: :any, mojave:   "5f59d37a3d8797777a90cb821e25b972a11e3ab2b956893fa573d23ba8c9477f"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
