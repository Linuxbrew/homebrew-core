class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.2-100/xmlcalabash-1.3.2-100.zip"
  sha256 "a445405c30be8441b687442ad93578e909e16bc895eb05b14830629014eaa07f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d7e1ea5236dca4abc850e97b1eecb44166d91f9700579a48b365783f695d553" # linuxbrew-core
  end

  depends_on "openjdk"
  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
