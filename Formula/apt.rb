class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://anonscm.debian.org/git/apt/apt.git"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apt/apt_1.4.7.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/apt/apt_1.4.7.tar.xz"
  sha256 "ea2a2e8e08daf8ea11aeaa86928d943a42ce53989165a30cc828838d470b7719"
  head "https://anonscm.debian.org/git/apt/apt.git"
  # tag "linuxbrew"

  depends_on "cmake" => :build

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    buildpath.install resource("gtest")

    args = std_cmake_args
    args << "-DWITH_DOC=OFF"

    system "cmake", ".", *args
    system "make", "install"

    # Install the development files too
    include.install apt-inst
    include.install apt-pkg
  end

  test do
    assert_equal "apt 1.4 (amd64)", shell_output("#{bin}/apt --version").chomp
  end
end
