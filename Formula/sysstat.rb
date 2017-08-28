class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v11.6.0.tar.gz"
  sha256 "6a71c95b0ef645b4f0809b847272ffd79a9ffede21db5366738de10ffb49cab9"
  head "https://github.com/sysstat/sysstat.git"
  # tag "linuxbrew"

  bottle do
    sha256 "f57d5096ecf589c47d166f5bafa000462c0f478c2c2bb775c564d27cba9b0296" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure",
      "--disable-file-attr", # Fix install: cannot change ownership
      "--prefix=#{prefix}",
      "conf_dir=#{etc}/sysconfig",
      "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    system "#{bin}/sar", "-V"
  end
end
