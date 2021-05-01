class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20210424.tar.xz"
  sha256 "0f9a7c0657e6119d317a0bab453aeb5140111b186ae10f62cfa081eecf2f03ba"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e1539282f81b36be58a03cf7e187a2137d1fc6d697275fec83b04791936872ef"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    on_macos do
      assert_match "be utun", pipe_output(prog)
    end

    on_linux do
      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
