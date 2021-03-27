class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.02.0.tar.gz"
  sha256 "573ab40de4e4dd3ca56d1e73fc913e3f6495c2331c4b71b1e4c48626499c0a6c"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 arm64_big_sur: "3bad4d99fc33460e381b1b601cc54811396933d23caa6991bad504bf9e89fe98"
    sha256 big_sur:       "e15dcc46f0848c6c7d6a1b68f4a76b6d3329fb3d381e4c07cd41e1dc1c2b0383"
    sha256 catalina:      "e66764ba84d6fb8df4c9816c0e8ec84db840e8aa978abaa35e6fb8cec98e21a0"
    sha256 mojave:        "d8ae8e9d2d931fd612ece6980ef11223305d6bd80870b0f844d31fa176b72fed"
    sha256 x86_64_linux:  "d00e2897ca0a1e8462567b41b21c23a60c331cedd1d56b5391e2f9006b9f3ee1"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxmac"

  def install
    mkdir "build-wxm" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
      prefix.install "src/wxMaxima.app" if OS.mac?
    end

    bash_completion.install "data/wxmaxima"
    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima" if OS.mac?
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    on_linux do
      # Error: Unable to initialize GTK+, is DISPLAY set properly
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
