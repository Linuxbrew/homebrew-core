class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.46.tar.gz"
  sha256 "71d84dfceec5971a00aae10b4972205e4bd6574c5dee4e6c893f7829732298e8"
  license "MIT"
  head "https://github.com/nodenv/node-build.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b7106ac8fe27fd03b7da33fd7cbb8a21c81d86e845195f757815161a039a8643" # linuxbrew-core
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
