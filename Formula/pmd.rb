class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/6.34.0/pmd-bin-6.34.0.zip"
  sha256 "fb2f85fd36a243116340b6aafcbbb74eac982c27f8c22cd0860f1e08aef63a4c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b1d9d7cc7df65b103bdffba16119bfc49c6a4922dbf0ef59a4083ce4c3e4e8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "779884d72d65f696a47dd59c6524852c287d3f1d205d09ed37d041b7ada58415"
    sha256 cellar: :any_skip_relocation, catalina:      "779884d72d65f696a47dd59c6524852c287d3f1d205d09ed37d041b7ada58415"
    sha256 cellar: :any_skip_relocation, mojave:        "779884d72d65f696a47dd59c6524852c287d3f1d205d09ed37d041b7ada58415"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/run.sh", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      Run with `pmd` (instead of `run.sh` as described in the documentation).
    EOS
  end

  test do
    (testpath/"java/testClass.java").write <<~EOS
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    system "#{bin}/pmd", "pmd", "-d", "#{testpath}/java", "-R",
      "rulesets/java/basic.xml", "-f", "textcolor", "-l", "java"
  end
end
