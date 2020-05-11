require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"
  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9d58f8af6b9ad778cb5a0b606bfabf540c2ce103c91b8b5f90e919d5a3f5814d" => :catalina
    sha256 "4ddc9cf7855dadffd1a72c17b3e30f9ff5854cbff797947289154be03923d3cd" => :mojave
    sha256 "9625f315c60972e02a84dd42bcdbc237c30079e9e7d8808cd376b17bfd3abb4d" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def install
    install_cabal_package "-f", "executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line =
      '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">' \
      "*hello, world*</code></pre></div></body>"
    assert_equal expected_last_line, test_output_last_line
  end
end
