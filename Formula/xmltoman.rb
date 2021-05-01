require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0"
  revision 1 unless OS.mac?

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "40871825d4de904971e52f8f68d362e947e3611bd5c3a6ff58d880d04416102d"
  end

  uses_from_macos "perl"

  on_linux do
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    on_linux do
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end

      inreplace "xmltoman", "#!/usr/bin/perl -w", "#!/usr/bin/env perl"
      rewrite_shebang detected_perl_shebang, "xmlmantohtml"
    end

    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w[xmltoman.1 xmlmantohtml.1]
    bin.install %w[xmltoman xmlmantohtml]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    pkgshare.install %w[xmltoman.xsl xmltoman.dtd xmltoman.css]

    on_linux do
      bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  def test_do
    assert_match "You need to specify a file to parse", shell_output("xmltoman")
  end
end
