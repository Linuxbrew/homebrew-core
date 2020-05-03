class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.1.1/pdftk-v3.1.1.tar.gz"
  sha256 "7538772dfc9a8b7a969d13f4a61ce693e77026043fb205a4839db92a9a7b8f51"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae6790bdcf8eb9d44defd8cf082f09a97aed55f9ddfbf250b655d50e88985eb2" => :catalina
    sha256 "e4bbfd10d2c57095fcdb0d85217a2fe28ac14dff4d74c2b857751df56b050689" => :mojave
    sha256 "c9c8962a32595706de8a7f57fa490dd92b6ad49aa7b09aca23f3dce4bafadd79" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", :java_version => "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
