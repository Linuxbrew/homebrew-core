class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/archive/v4.15.tar.gz"
  sha256 "e5fc45bdf72a36e621868ff4c67d645a5087d3d2f31571ad6bca21c64b5ac870"
  head "https://github.com/strace/strace.git"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "038d8d843299fe9d92b858e5349354004d71c3aa14e4e1c91c076445ccbd3669" => :x86_64_linux
  end

  depends_on "linux-headers"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
