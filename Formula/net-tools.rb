class NetTools < Formula
  desc "Linux networking base tools"
  homepage "https://sourceforge.net/projects/net-tools"
  url "https://downloads.sourceforge.net/project/net-tools/net-tools-2.10.tar.xz"
  sha256 "b262435a5241e89bfa51c3cabd5133753952f7a7b7b93f32e08cb9d96f580d69"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a5be21d42280ba9e5bbbd99e94e3e2b7647741ffa36835a015c98b0aa3a1639"
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
    assert_match "Kernel Interface table", shell_output("#{bin}/netstat -i")
  end
end
