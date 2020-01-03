# wxmaxima: Build a bottle for Linux
class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.12.4.tar.gz"
  sha256 "530f8023b31d109e04385b7357b585ec539f6366aa07090544f81c9493baef5e"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "3bc6c5a288dc0b797a9fae78f105b00bd98eb91c20c8fd40c79d96b787478525" => :catalina
    sha256 "d76d9045ce52e6b563c32dda4d5d3960fa35086b3dd95ab17cd32312de8c9994" => :mojave
    sha256 "0d9531d94f451f694e1c76d328fa05bc447aaf91a11b4cdaa20180da7f1c42c4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app" if OS.mac?

    bash_completion.install "data/wxmaxima"
  end

  def caveats; <<~EOS
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
  EOS
  end

  test do
    # Test is disbaled on Linux as circle has no X (Error: Unable to initialize GTK+, is DISPLAY set properly)
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1", 255) if OS.mac?
  end
end
