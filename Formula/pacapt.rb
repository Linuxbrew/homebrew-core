class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.2.tar.gz"
  sha256 "8eca774fbf58695cecb3160081db467e92deafba545ad6477937d1e98bc8b88e"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4c4bd5edea42dd8e0ad6a5315b3960daa84b360e87619e7843599d63b79758c" # linuxbrew-core
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
