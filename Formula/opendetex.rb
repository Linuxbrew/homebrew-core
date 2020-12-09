class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.9/opendetex-2.8.9.tar.bz2"
  sha256 "0d6b8cb1f3394b790dd757b0171ad8b398c48e306fa6339e86ed8303c51df084"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce26ea02e5c47385374aba395951434319d5e48e6dbda94f7ffa25e4632b54a6" => :big_sur
    sha256 "46db3f033cb646e360fcabc83eb6fabba87b858eb1cc3e32d4bad78e73816bc6" => :catalina
    sha256 "92d55157d568aa004dd09342308f8e4be8dfb6a95f9719646c5d9792b677f7a2" => :mojave
    sha256 "ac5c6fc89178079f6081d9a57eebe9b3d5ad72c82d20e5d64c79d097aee7a4f7" => :x86_64_linux
  end

  uses_from_macos "flex" => :build

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Simple \\emph{text}.
      \\end{document}
    EOS

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end
