class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.05/nqp-2020.05.tar.gz"
  sha256 "291b92d9db968a691195adb1c9533edc1076d12d6617d6d931e40595e906b577"

  bottle do
    sha256 "b44f973899dd832a35119eda9fe14a2f6e3e4d94cbb25b0d265fdfd66d607a9e" => :catalina
    sha256 "53b6c84315b97bee2c25f8787d0f5a0770326fd8cf3c9cb49087a88a7845d7e4" => :mojave
    sha256 "29c3aa22c0b46144698e4df76be14d7ee0d821cdb86e68f5a73d5207e9176b76" => :high_sierra
  end

  depends_on "moarvm"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
