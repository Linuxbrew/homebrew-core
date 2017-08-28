class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.8.1.tar.gz"
  sha256 "1433f9f9958b104c97d4b23ab77a2ac37d3f98b826437b941052a55c01c721b4"
  revision 1 unless OS.mac?

  head "https://github.com/ranger/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53183d431e6bcf9cf49a462130fb5e0929a4bf557a2d109c354e3194bfd36cc0" => :sierra
    sha256 "224dce8bf10cb4f29a182e00d8a684a388f5dc1544f427149ee85e050c07a833" => :el_capitan
    sha256 "224dce8bf10cb4f29a182e00d8a684a388f5dc1544f427149ee85e050c07a833" => :yosemite
    sha256 "487beb167e7f44cdcf86ce6fb8bcc12f5406bf070f8a662d55a554d03bb9139e" => :x86_64_linux # glibc 2.19
  end

  depends_on :python unless OS.mac?

  def install
    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    cmd = OS.mac? ? "script -q /dev/null #{bin}/ranger --version" : "#{bin}/ranger --version"
    assert_match version.to_s, shell_output(cmd)
  end
end
