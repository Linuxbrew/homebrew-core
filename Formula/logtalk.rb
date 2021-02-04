class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3440stable.tar.gz"
  version "3.44.0"
  sha256 "429088a4fea3fae3832946f12bdff5e24a1d99a55f07b1669ea99b54096a93fa"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "7f92e746a72fb33582555a78a128db9d48dd74bfd1e28d119b9d3a834dddbd6c"
    sha256 cellar: :any_skip_relocation, catalina:     "e1c9def39f7585aaa0047fc8a0550a02820b796ba6691a437487f589ca56573c"
    sha256 cellar: :any_skip_relocation, mojave:       "da60c7e264ea48b3990ab4dcc0cbd3c9cc33e7c37b076671f8da7f071e96ee90"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01c1f093e393e5e5ec9ab6ee3895595adc33d77dd176d00892b27f27b90c3d5b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
