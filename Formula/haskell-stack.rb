class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.1.tar.gz"
  sha256 "eb849d5625084a6de57e8520ddf8172aca64ddadd9fee37cdafeefad80895b62"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7910094fb9d9c7653c03df03d4b46a13266d685cdf41e1ffc765aaa40c6bd3d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a79fbaaa5a4d95b1d7a1075ce197aaf6430575a3ad897073fae481c45b3092e"
    sha256 cellar: :any_skip_relocation, catalina:      "9029316df99f2db7c5771c7d186d6e749cca6189f0810b816048c771ddd47cc6"
    sha256 cellar: :any_skip_relocation, mojave:        "dcf61ed173b28d67502357a7a4eb6bc3ac3c656df59556099591906bcb3a3e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f25db2a2614a4fb5481bca5f53a1d102d82eb9ddafc20074fb61e2cae8091b7" # linuxbrew-core
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
