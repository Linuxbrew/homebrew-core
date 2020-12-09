class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.59.tar.bz2"
  sha256 "85926ca8e08e69b497fa4a0c93bec595e15c1ca18c4ee494ea3f1c9a78c249a2"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "efb65db7b5870241ff19c71d1d6dc4a85c60f8690cfe8f468f0320b1b58b3c4a" => :big_sur
    sha256 "b22c1b722fae83da1833f8163b4714048b99d580c1a8593e873174e74433cecc" => :catalina
    sha256 "325b04e55f31cbc7e05101911eb915f7fd4919544d1753bcd875ab0c25b1086d" => :mojave
    sha256 "adc7c962d1d46b607e47c050fe2dcc2c21e76350b27ca8da5ca46279c80a6ab1" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
