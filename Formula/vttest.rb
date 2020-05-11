class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20200420.tgz"
  sha256 "6c9019c72c31b12d861783890a50ec5145a3424ee634c319b158af9af630910e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3203719ed3132e7f57b3e5bab9341640a4626697a8b2c2fb01cccfad004b688d" => :catalina
    sha256 "ed6fc309514156d4253b0ad03f809c326095f413033a18c38a49c46281396075" => :mojave
    sha256 "2bfa2183868d51e54212a0d8b71fca79e583b8850547407056e853e3f52b293b" => :high_sierra
    sha256 "4858946fa444be6883a8fa4bfe4da1ddd7f6ee67fef7b996def73afacd68c253" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
