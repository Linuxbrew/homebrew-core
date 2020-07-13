class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.6.0.tar.gz"
  sha256 "c082e234e89928f5facd33dfa57ecb1de88b246429a8e88a3e14b7d69ce52964"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dcbe4416e8bf6e460f0061878b9a0efda09586f34b91cebbca3851c929378d4" => :catalina
    sha256 "7dcbe4416e8bf6e460f0061878b9a0efda09586f34b91cebbca3851c929378d4" => :mojave
    sha256 "7dcbe4416e8bf6e460f0061878b9a0efda09586f34b91cebbca3851c929378d4" => :high_sierra
    sha256 "62d0563681c7cf55f0a2219854dc8a918e7ad0fd0a6cba2e2a2860030d4ffb30" => :x86_64_linux
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
