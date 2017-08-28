class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.4.tar.gz"
  sha256 "9f4e6fe737300878c3c9ca6ed09ed97fc2edbf40e4cf37bd61f48a27f5adf952"

  bottle do
    rebuild 1
    sha256 "96ced10b5fdddf2c8489cf9eaf1f20a85ebee73561340c34fcdf8ede5c859ec9" => :sierra
    sha256 "0bd0cb29369b4b029351095fad544573241c791d700424cc937f33cabd034d32" => :el_capitan
    sha256 "3a4f0f3c1a15208a03e6518b6a3e483f9340801a8121fcb637c458992d422d9b" => :yosemite
    sha256 "7af101788f37c9719cc2b8eb09695cb146f068a669c471717841494329e223ff" => :x86_64_linux # glibc 2.19
  end

  depends_on :x11 => :build
  depends_on "ncurses" unless OS.mac?

  # Fixes bashism in makefiles/installsh
  # Remove on next release
  patch do
    url "https://github.com/cisco/ChezScheme/commit/6be137e5b76c6a8472e311a69743a403adc757f5.diff"
    sha256 "098611b16ed92993cc0c31ec8510bd26c81dee38b807c3707abb646b220b5ce0"
  end unless OS.mac?

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Feb 2017 https://github.com/cisco/ChezScheme/issues/146
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "c/stats.c" do |s|
        s.gsub! "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_PROCESS_CPUTIME_ID", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_REALTIME", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_THREAD_CPUTIME_ID", "UNDEFINED_GIBBERISH"
      end
    end

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
