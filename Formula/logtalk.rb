class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3480stable.tar.gz"
  version "3.48.0"
  sha256 "d7e727b33692947f7cba8e51e5a157bd46b852367c6b7229eba1e35ad12ee005"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8e9dd986617f15016de9ca3de1ff04c377339d67bafe657cbec9b9efb961f627"
    sha256 cellar: :any_skip_relocation, catalina:     "4fa6488a7be05070b60ca6b2f011ac1a3d6fdfebc9ca2ebfe493caca42a5b2e7"
    sha256 cellar: :any_skip_relocation, mojave:       "9eb6601db3d44df27539aeca4ba1c2fe55ee9d1365666b9e8fa750e5c9fdccac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5ccaa66e9e94a1a33c6280b97e18477414d475fdf36a45b3af164f2a881e6e2e" # linuxbrew-core
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
