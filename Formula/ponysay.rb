class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6657b674719935d9ff4114119e2521ff967eb1ae13f72185d20e760949ee5b" => :catalina
    sha256 "f0a79ed95066b8ee79f4e117ae4344ac516c32a73e30e8f036abca646e7f3c56" => :mojave
    sha256 "a502ed3340bc2c7591788c8747c8175e0ac7902bfbfdf73454aef09d39a0db16" => :high_sierra
  end

  depends_on "coreutils"
  depends_on "python@3.8"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.8"].opt_bin}/python3",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
