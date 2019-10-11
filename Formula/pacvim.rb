class Pacvim < Formula
  desc "Learn vim commands via a game"
  homepage "https://github.com/jmoon018/PacVim"
  url "https://github.com/jmoon018/PacVim/archive/v1.1.1.tar.gz"
  sha256 "c869c5450fbafdfe8ba8a8a9bba3718775926f276f0552052dcfa090d21acb28"
  head "https://github.com/jmoon018/PacVim.git"

  uses_from_macos "ncurses"

  # Use ncurses.h instead of cursesw.h which is not installed by brew
  unless OS.mac?
    patch do
      url "https://github.com/jmoon018/PacVim/pull/31.patch?full_index=1"
      sha256 "e5b753de87937c0853a1adbab31eb1ec938add4ceb0df26eafef5b4f613bc3e6"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "85bd0087ecc54716772881e46ce00553ee037eb2ea200d34d5db28709092369f" => :catalina
    sha256 "e2ecd6cc1337adb4c9e760c50a83ae04a8cb86495d3c1ea167bfa5930d7a16a0" => :mojave
    sha256 "b8ef8cdba34802db97fba770e013393973e908e11486b87a4f5189f139e468dc" => :high_sierra
  end

  def install
    ENV.cxx11
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_predicate bin/name, :exist?
  end
end
