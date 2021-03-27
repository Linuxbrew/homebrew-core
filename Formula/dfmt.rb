class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      tag:      "v0.13.3",
      revision: "3479e737076a156518e4d32575029161151c0c8f"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfmt.git", branch: "v0.x.x", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "1bc5497e78eab3c0bb8922f1cd9838ee230b09523d96d26735ce7eeec865dd46"
    sha256 cellar: :any_skip_relocation, catalina:     "f548f11c95dbb62c34cc6479693e662bcf200eb84c56928f29749cae6caf9155"
    sha256 cellar: :any_skip_relocation, mojave:       "7ede9b79a313b17cd4820832c6cf0eb7140247f78a243403dc667519d431e96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2bf588844e1aec2ae95438d82a25396c472f728401ab807b99d521bdd0222681"
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
