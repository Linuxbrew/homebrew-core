require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.32.tar.gz"
  sha256 "c45d680a2a00ef9524fc921e4c10fc7e68f02e57f4d6f1e640b7638a2f49c198"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    rebuild 1
    sha256 "be536847f887c7e81974ee0f2853d35c8432decd34f5be604a41ff37da459012" => :catalina
    sha256 "39b5aa8e661d3f56f0e7e82bd9d30276ed5a2212a73e7f381070e251f7034e8a" => :mojave
    sha256 "09ef5c68ea4b09732b75e8aa9859e1b70e54cef0ad963e03b59d32d11a34f3e2" => :high_sierra
    sha256 "110a7bf0335bd3283eb6819b69467ded55ac48676b5810cc16e5afb1a23ba47d" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
