class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v5.2/strace-5.2.tar.xz"
  sha256 "d513bc085609a9afd64faf2ce71deb95b96faf46cd7bc86048bc655e4e4c24d2"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "0784954f127ecf884dcdc9fbb148b8c808097c06b322ba629fc37dc3e4639b9c" => :x86_64_linux
  end

  head do
    url "https://github.com/strace/strace.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "linux-headers"

  def install
    system "./bootstrap" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--enable-mpers=no" # FIX: configure: error: Cannot enable m32 personality support
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
