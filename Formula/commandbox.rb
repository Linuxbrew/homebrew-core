class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.3.1/commandbox-bin-5.3.1.zip"
  sha256 "f0e1f3b989a8664c3f7d0f02362ae8b0f3ab0ecd2b923b3ceeb89a4cf46cb614"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17d80c467ecde009f3ea89a115ed3f6d4b310e84d57fbd94a8362907f24ce2b8" # linuxbrew-core
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.3.1/commandbox-apidocs-5.3.1.zip"
    sha256 "2090d90b7f53e4e776178d55ac12ae2fc5ec3d05a217cc60f02587a338f306cf"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.overridable_java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
