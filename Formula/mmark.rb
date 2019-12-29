# mmark: Build a bottle for Linux
class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.1.tar.gz"
  sha256 "fe98d36c1519bea70cda9144c9ebe9f28b5828730fd76cb20f34803de8353cb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0112d194270c212d6d99cbe03835603343ffa9174e0a6a4ca0f358ccb1dc0e6" => :catalina
    sha256 "b0112d194270c212d6d99cbe03835603343ffa9174e0a6a4ca0f358ccb1dc0e6" => :mojave
    sha256 "b0112d194270c212d6d99cbe03835603343ffa9174e0a6a4ca0f358ccb1dc0e6" => :high_sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/master/rfc/2100.md"
    sha256 "0b5383917a0fbc0d2a4ef009d6ccd787444ce2e80c1ea06088cb96269ecf11f0"
  end

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"mmark"
    man1.install "mmark.1"
    prefix.install_metafiles
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
