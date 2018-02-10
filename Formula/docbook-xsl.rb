class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https://docbook.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/docbook/docbook-xsl/1.79.1/docbook-xsl-1.79.1.tar.bz2"
  sha256 "725f452e12b296956e8bfb876ccece71eeecdd14b94f667f3ed9091761a4a968"
  revision 1 unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "e80af394f337e21fcdbc8c8f6f0822559bfa71e5aacb192450aa71c5e0dc2257" => :high_sierra
    sha256 "4e63a12e69dc7cf292c1f4fd8f1c54f544887b809618b80b5fc3fc780f492f77" => :sierra
    sha256 "ae0cdc12fcfa0b8a1c4e72532c4bf49697de862017f5a5820093cdd26ac24e06" => :el_capitan
    sha256 "4390c7e9a0e06aeb05cc950b04991bca819279e1ced05763073b65860867a9a5" => :yosemite
    sha256 "b6166ebd526d11e436d6138d53160774b5ff95c5ff5fe5cd34841185d7529855" => :mavericks
  end

  depends_on "docbook"

  # Fixes: #12 replacement target string #13 target string #14 string
  # error: file man/systemd.index.xml xsltRunStylesheet : run failed
  # when building systemd
  patch :DATA

  resource "ns" do
    url "https://downloads.sourceforge.net/project/docbook/docbook-xsl-ns/1.79.1/docbook-xsl-ns-1.79.1.tar.bz2"
    sha256 "36ca9026e05b8985baebd61a23af8ded8e2cf71cc3163b673159c9d78a7b0f9c"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files
    end

    bin.write_exec_script "#{prefix}/docbook-xsl/epub/bin/dbtoepub"
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    [prefix/"docbook-xsl/catalog.xml", prefix/"docbook-xsl-ns/catalog.xml"].each do |catalog|
      system (OS.mac? ? "xmlcatalog" : "#{Formula["libxml2"].opt_bin}/xmlcatalog"), "--noout", "--del", "file://#{catalog}", "#{etc}/xml/catalog"
      system (OS.mac? ? "xmlcatalog" : "#{Formula["libxml2"].opt_bin}/xmlcatalog"), "--noout", "--add", "nextCatalog", "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  test do
    system (OS.mac? ? "xmlcatalog" : "#{Formula["libxml2"].opt_bin}/xmlcatalog"), "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl/snapshot_9899/"
    system (OS.mac? ? "xmlcatalog" : "#{Formula["libxml2"].opt_bin}/xmlcatalog"), "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl-ns/1.79.1/"
  end
end

__END__
--- A/lib/lib.xsl
+++ B/lib/lib.xsl
@@ -10,7 +10,10 @@
      This module implements DTD-independent functions
 
      ******************************************************************** -->
-<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+                xmlns:str="http://exslt.org/strings"
+                exclude-result-prefixes="str"
+                version="1.0">
 
 <xsl:template name="dot.count">
   <!-- Returns the number of "." characters in a string -->
@@ -56,6 +59,9 @@
   <xsl:param name="replacement"/>
 
   <xsl:choose>
+    <xsl:when test="function-available('str:replace')">
+      <xsl:value-of select="str:replace($string, string($target), string($replacement))"/>
+    </xsl:when>
     <xsl:when test="contains($string, $target)">
       <xsl:variable name="rest">
         <xsl:call-template name="string.subst">
