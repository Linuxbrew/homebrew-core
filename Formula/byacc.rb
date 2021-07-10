class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210619.tgz"
  sha256 "acdd6080dcf935732a08ec8e8c4c161c666cd56d8c490739c6dbb6267a498c0e"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65a66cf10f66fd03e87115464f198593a4ff109bd8271ac0dd8827cc225bb24c"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ace0af560e8b91c4d6b4755c6701d13b7f4757a9e7d523f44ae0cba45e8bdb5"
    sha256 cellar: :any_skip_relocation, catalina:      "4c074897b184addd2e0ae251c39901c4099fd92b194240c5d22c010226c0ce55"
    sha256 cellar: :any_skip_relocation, mojave:        "49a84ba13ab75461bd8b116f42f3217dd554a425f343d17900ea60007cd4b29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a35f06a724ecd4733b3e4259c8868a233eeaeecf369d265f3ee0be02b5fdd91" # linuxbrew-core
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
