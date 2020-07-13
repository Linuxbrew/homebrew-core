class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2020.01.16/kakoune-2020.01.16.tar.bz2"
  sha256 "a094f1689f0228308f631e371b382b0c0522391fc8b6c23a6cbc71ff404a0dae"
  license "Unlicense"
  revision 1
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "4190698871db5696c3dbbdcca4c15d26ed8858451db4e0a4ddb8a10fff71afab" => :catalina
    sha256 "c62c3102bbed733f1f00ed64fafa1f07353b78d59f1a35e7a1746d2e35bc698c" => :mojave
    sha256 "7fc5a7b69fe56f47b24a2e4c1074319963e3b7c0a0c92f3c0d0688f57eb2a278" => :high_sierra
    sha256 "963f14db69ad3a7cae0288770decbac28a9ec7e90f02dbc7f501a433bd2392c5" => :x86_64_linux
  end

  depends_on :macos => :high_sierra # needs C++17
  depends_on "ncurses"

  unless OS.mac?
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    depends_on "binutils" => :build
    depends_on "linux-headers" => :build
    depends_on "pkg-config" => :build
    depends_on "gcc@7"
  end

  uses_from_macos "libxslt" => :build

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
