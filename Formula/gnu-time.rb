class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7be7fa7161f1c4256e7fd0427cc70bcb9942516cf087e3a4ce8bf25a8e9bda0e" => :high_sierra
    sha256 "4340f98cd4edd0512a7462ad52180a3dd4bd282fce7c53cadfe56c45f5367095" => :sierra
    sha256 "1f81b3521747ff00d913ac9f4c7e7d9ce8f19dd76a67c7d2b05d5dd228561883" => :el_capitan
    sha256 "17187494a6e02964e19812e57c8547734f2aeecf0ce2954e3fb6fb4523d2cc00" => :x86_64_linux
  end

  if OS.mac?
    option "with-default-names", "Don't prepend 'g' to the binaries"
  else
    option "without-default-names", "Prepend 'g' to the binaries"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--info=#{info}",
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    bin.install_symlink "time" => "gtime" if build.with?("default-names") && !OS.mac?
  end

  test do
    if OS.mac?
      system bin/"gtime", "ruby", "--version"
    else
      system bin/"gtime", bin/"gtime", "--version"
    end
  end
end
