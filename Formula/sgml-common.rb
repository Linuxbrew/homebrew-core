class SgmlCommon < Formula
  desc "Standard Generalized Markup Language"
  homepage "https://www.iso.org/cate/d16387.html"
  url "https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz"
  sha256 "7dc418c1d361123ffc5e45d61f1b97257940a8eb35d0bfbbc493381cc5b1f959"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  resource "html-dcl" do
    url "https://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/html.dcl"
    sha256 "61380e02a426f5f48b24f05a1b3bf446c882a13ff4e83706661ab5a0e14bbb49"
  end

  resource "html-soc" do
    url "https://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/html.soc"
    sha256 "f564e94f8d99948f1f1a56768ca68afe6198c0af31ea9a5cdac2b11fe78ccaf0"
  end

  resource "xml-dcl" do
    url "https://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/xml.dcl"
    sha256 "1068e172c737baefc5217b20631771ef83e4c5dd704f3f560a9f16c04f247d16"
  end

  resource "xmls-soc" do
    url "https://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/xml.soc"
    sha256 "e9d7967c700a7155a99c9490b8eee9364a9e20addbc5eee0dae203480782c2c1"
  end

  patch do
    url "http://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/sgml-common-quotes.patch"
    sha256 "b6b8b7d5b9ed72acfe104d18e4e6d89d53185b4f701fc39dbef0b1aae5cbca80"
  end

  patch do
    url "http://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/sgml-common-umask.patch"
    sha256 "e397d897242549eec5761db92f957801a262452f2de7afd065f3595fb96fed27"
  end

  patch do
    url "http://stash.tfm.ro/projects/TSERV/repos/server/raw/sgml-common/sgml-common-xmldir.patch"
    sha256 "7015210b5693f12c75e75c4e473496f5e818202c3fd14e78413f7ec21b69f55d"
  end

  patch do
    url "http://www.linuxfromscratch.org/patches/blfs/svn/sgml-common-0.6.3-manpage-1.patch"
    sha256 "50d93af704a0869faf8fedf5d23b1a9f90fff6499f4c11cf4addb5e460b7b58b"
  end

  def install
    File.rename "configure.in", "configure.ac"
    system "autoreconf", "-f", "-i"
    system "./configure",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install", "docdir=#{doc}"
    resources.each do |r|
      share.install r
    end
  end

  def post_install
    inreplace "#{bin}/install-catalog", "/etc/sgml", "#{prefix}/etc/sgml"
    inreplace "#{bin}/sgmlwhich", "/etc/sgml", "#{prefix}/etc/sgml"
    inreplace "#{prefix}/etc/sgml/sgml.conf", "/etc/sgml", "#{prefix}/etc/sgml"
    inreplace "#{prefix}/etc/sgml/sgml.conf", "/usr/share/sgml", share.to_s
    system "#{bin}/install-catalog", "--add", "#{prefix}/etc/sgml/sgml-ent.cat", "#{share}/sgml/sgml-iso-entities-8879.1986/catalog"
    system "#{bin}/install-catalog", "--add", "#{prefix}/etc/sgml/sgml-docbook.cat", "#{prefix}/etc/sgml/sgml-ent.cat"
  end

  test do
    assert_predicate etc/"sgml/sgml.conf", :exist?
  end
end
