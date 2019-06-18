class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "https://scrollkeeper.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"
  revision 2

  bottle do
    sha256 "0d7cbee6e25a46848d7c387ba07c4ee110ae2256953d2e5addd26f68e21c645d" => :mojave
    sha256 "efa4637b9d1b3942192dca6fb4602ef72ec6b285ba424c087d290c8feb5e2c5b" => :high_sierra
  end

  depends_on "docbook"
  depends_on "gettext"
  uses_from_macos "libxslt"
  depends_on "perl" unless OS.mac?

  conflicts_with "rarian",
    :because => "scrollkeeper and rarian install the same binaries."

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
    sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end
end
