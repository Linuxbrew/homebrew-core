class NetTools < Formula
  desc "Linux networking base tools"
  homepage "https://sourceforge.net/projects/net-tools"
  url "https://downloads.sourceforge.net/project/net-tools/net-tools-2.10.tar.xz"
  sha256 "b262435a5241e89bfa51c3cabd5133753952f7a7b7b93f32e08cb9d96f580d69"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3356573f08d651305f57af733130adabf68f5f13e92ff4db5cdc0c069a94f73"
  end

  depends_on "gettext" => :build
  depends_on "libdnet"
  depends_on :linux

  def install
    system "yes '' | make config"
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    system bin/"netstat", "-i"
  end
end
