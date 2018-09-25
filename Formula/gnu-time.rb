# gnu-time: Build a bottle for Linuxbrew
class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8869676fa19dcc2454fe3444e71aed9544639c1e2988d04c02678bad9b281e35" => :mojave
    sha256 "22c847320019d76be1290c7e04943922bd91c39c8aaccca87e44d9a2327ceab8" => :high_sierra
    sha256 "2fa9dd90dc13901d0bc2ab792d334a264f992ee57302bbcdc42e45135457710f" => :sierra
    sha256 "a6ae05233326897ed622ab5c6ee63081e1c445b5e7496c68efa00dd5718b589c" => :el_capitan
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

    if build.without?("default-names") && OS.mac?
      (libexec/"gnubin").install_symlink bin/"gtime" => "time"
    end
  end

  test do
    if OS.mac?
      system bin/"gtime", "ruby", "--version"
    else
      system bin/"gtime", bin/"gtime", "--version"
    end
  end
end
