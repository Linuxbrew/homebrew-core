class Asciidoctorj < Formula
  desc "Java wrapper and bindings for Asciidoctor"
  homepage "https://github.com/asciidoctor/asciidoctorj"
  url "https://dl.bintray.com/asciidoctor/maven/org/asciidoctor/asciidoctorj/2.3.1/asciidoctorj-2.3.1-bin.zip"
  sha256 "8b5aa912d9106771359a3fa45ee35308ab538953c1db327394f4936ed609c386"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"] # Remove Windows files.
    libexec.install Dir["*"]
    (bin/"asciidoctorj").write_env_script libexec/"bin/asciidoctorj", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.adoc").write <<~EOS
      = AsciiDoc is Writing Zen
      Random J. Author <rjauthor@example.com>
      :icons: font

      Hello, World!

      == Syntax Highlighting

      Python source.

      [source, python]
      ----
      import something
      ----

      List

      - one
      - two
      - three
    EOS
    system bin/"asciidoctorj", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
    system bin/"asciidoctorj", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
    assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", :mode => "rb")
  end
end
