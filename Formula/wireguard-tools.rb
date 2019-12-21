# wireguard-tools: Build a bottle for Linux
class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20191219.tar.xz"
  sha256 "5aba6f0c38e97faa0b155623ba594bb0e4bd5e29deacd8d5ed8bda8d8283b0e7"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "a1b7da4446cf1660b0c29d3ed3cacf9db5c6fba70d174c718aae69d4d3cae5de" => :catalina
    sha256 "64f13166f0bdc97d7685f26343bb25de53027d935e9ec750ce2b59c49033eda8" => :mojave
    sha256 "37ffbc30f283c5d47e015b08be14f71b42402eafb2da38a08cca9119d3e89e8e" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"
  depends_on "libmnl" unless OS.mac?

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
