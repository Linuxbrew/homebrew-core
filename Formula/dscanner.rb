class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.11.1",
      revision: "7809598da0e06a319d35d3b6edb4277710fa776b"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8ae2af163a23040c10f272d0444e1d6c77985ea31db552efcfa79276055287bb"
    sha256 cellar: :any_skip_relocation, catalina:     "fc89a3f0681d1cc292db4e4e2290bcf17293005da44ac79b4de1dcf6c99fca0d"
    sha256 cellar: :any_skip_relocation, mojave:       "3b169fd293837fea2ddadf82c21513b468019f2e37218e207a16c3cfd6d58289"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9dbf56e28ed6da8624a01140ef14211fe4747046eb44fb50159149cb7bf4ddf" # linuxbrew-core
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
