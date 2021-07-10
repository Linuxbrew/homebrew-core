class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/6.36.0/pmd-bin-6.36.0.zip"
  sha256 "a3aa27cfa8f72ca56aaaa1f56468ea1decfb1b0d1b57005b4f3c386cb80be7fe"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb838507485f5d8c8f275d3364c6a2b3addb86dbc1eb395e184cc856c3e07283" # linuxbrew-core
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
