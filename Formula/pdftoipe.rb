class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    cellar :any
    sha256 "f9c11057d20cbd8282f6dbba4ad7c1fe454c22b42dcef1a5d54893423d2f4232" => :catalina
    sha256 "b1a1a3704b722cf813c4197e8813da94bb0b6c0d7d758f20ad9b57452db0061d" => :mojave
    sha256 "241781a2d664a07541d50b5eeb4ee6f77185be3e7c2132cef4484dbc2fe3babb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
