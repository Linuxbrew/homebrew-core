class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.7.tar.gz"
  sha256 "fbe26efbed8b467352f313b92f8617d873c8cf0209fb6377572cf8d1ddc2747c"

  bottle do
    cellar :any
    sha256 "ff5d1ec8531b1e5994b6b822e94c9c92bfaed8d7918257e08b37c76aa4920d51" => :high_sierra
    sha256 "8be6a30a848f30382065ffdfcf0aaf17f59ce5239bba5b263f19e69ff3ea3a2d" => :sierra
    sha256 "c4884ba21bdcc444dfb2ef3df4ddd8f7f56194c159fec96fcef038092564c794" => :el_capitan
    sha256 "5b9cf055ab1843d9af54e6d7db4057220ef5d83620defab564b8fbf1ad9f61c4" => :x86_64_linux
  end

  depends_on "readline"
  depends_on "ncurses" unless OS.mac?

  # Upstream PR from 27 Feb 2018 "Makefile: don't use non-portable -t option"
  patch do
    url "https://github.com/jarun/nnn/pull/83.patch?full_index=1"
    sha256 "e3196f69407a81b19cd42c9fafb6b420d99ebeed592dd0948efbb9665a6c4a9f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if ENV["CIRCLECI"] || ENV["TRAVIS"]
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
