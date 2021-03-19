class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.49.tar.gz"
  sha256 "c04daaa724c5c99fd209a6f5ab384bbff77518760f52f9dbe78bdf252e9468f8"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a48d716bb48256f028b7d25f4cebef804946833b4778619bb7bcb3a18856bf66"
    sha256 cellar: :any_skip_relocation, big_sur:       "50ce1db9a6fcc59b37e873b62750c82a1bc8ed36af64342afa533f39a52046d7"
    sha256 cellar: :any_skip_relocation, catalina:      "2ad832b9d2eba7c3c197e67828d41b4ff112dca9af8db7fe71b2fd745f983b74"
    sha256 cellar: :any_skip_relocation, mojave:        "7381006ae44f23fab65ddb4da6aad65e1aca43180cc212a3bf12e51bbc808503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974e41345f16cced4a3a103b3c01d70b4ee4fb5b1aac437c626dddcfe6a1fb7d"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
