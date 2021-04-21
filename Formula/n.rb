class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.2.1.tar.gz"
  sha256 "64c22d111f606d33043718147f5dd924e492578c34c6d769416e9078d35c0380"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d48818412130b3b814641e8c7eec81a1c28cdd40448758e5e79ea9b258dd5d21"
    sha256 cellar: :any_skip_relocation, big_sur:       "2bbef166a31db55738ef621c11b5ec967daa4442dab3eb0bd336fa83e756deda"
    sha256 cellar: :any_skip_relocation, catalina:      "2bbef166a31db55738ef621c11b5ec967daa4442dab3eb0bd336fa83e756deda"
    sha256 cellar: :any_skip_relocation, mojave:        "bfba14563291de6675278c5d2a6ba81f01e185daa4da3ecf9e4191ebfb6b8012"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
