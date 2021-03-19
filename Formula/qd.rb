class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.22.tar.gz"
  sha256 "30c1ffe46b95a0e9fa91085949ee5fca85f97ff7b41cd5fe79f79bab730206d3"
  revision 1 unless OS.mac?

  livecheck do
    url :homepage
    regex(/href=.*?qd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "a142fb3e68694ee7529043e985fd898069553ec2ca37483336b6ead7246e28bc"
    sha256 cellar: :any,                 big_sur:       "380c30f837eed2027f1f1a353cfca4b5f71f551e504c26b2ab635cba4918681b"
    sha256 cellar: :any,                 catalina:      "9700e6163692f31c736ddd74f535305fef730e021c4ca9f85b5860926397e330"
    sha256 cellar: :any,                 mojave:        "53e4efc8ab2d1c18b1c4198bed031eb1b97b4431b1c0a4e8e4195c9b01659098"
    sha256 cellar: :any,                 high_sierra:   "0ff67d07426a90d2897f0f69da0bd91bedb8a40ea52c0201c80225dd6c22510d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd17ada14d5480d3d3da703b1e6cd2de7d50df46f2c7f08dfa9158d50d51c74e"
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
