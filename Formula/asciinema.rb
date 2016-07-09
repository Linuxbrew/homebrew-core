# asciinema: Build a bottle for Linuxbrew
require "language/go"

class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.2.0.tar.gz"
  sha256 "64b8c2b034945a99398c5593fd8831c6448fd3b6dd788a979582805bfdcb5746"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a912cac0c3f63fdf3e102cbde0b1a42895c80d176f9bb9116a00f3835b5d9260" => :el_capitan
    sha256 "845f9ac6d0a94b7938583baf12485edc678334d7ce3758a629f76eeabac99e1f" => :yosemite
    sha256 "b92022ad9a785aebbedc1cbd19160eba65416070dea34f5cb8d5d2de7e6d0315" => :mavericks
    sha256 "0943e1aa9a774e2af7c3a7d7e2154a9b8b63e7b95732a11d0caf7e3ab67452e5" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/asciinema"
    ln_s buildpath, buildpath/"src/github.com/asciinema/asciinema"

    system "go", "build", "-o", bin/"asciinema"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
