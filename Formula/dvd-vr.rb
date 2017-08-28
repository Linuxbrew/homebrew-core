class DvdVr < Formula
  desc "Utility to identify and extract recordings from DVD-VR files"
  homepage "https://www.pixelbeat.org/programs/dvd-vr/"
  url "https://www.pixelbeat.org/programs/dvd-vr/dvd-vr-0.9.7.tar.gz"
  sha256 "19d085669aa59409e8862571c29e5635b6b6d3badf8a05886a3e0336546c938f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b38c83a9bb9daded6a6f28be018076cdcdbbfb0d47102ecbdd06128bebb33ee" => :sierra
    sha256 "a048c7985df06e3a1d4c7145064b87bd51945f15da2494c03e7af542f07ca8b4" => :el_capitan
    sha256 "22919ace8aeedc16d406797273402498c0c97ceec31e2dfbffcba6fff957ce65" => :yosemite
    sha256 "1a88e4ac057d6ae1fef7f0e82342ce3f6e80f40a4c7cde9a46bfb55bd1d0875b" => :x86_64_linux # glibc 2.19
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/dvd-vr", "--version"
  end
end
