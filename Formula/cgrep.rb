# cgrep: Build a bottle for Linux
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.31.tar.gz"
  sha256 "82a0a459f06aa2050d52b645f2f0f7d9fc1fc798a2660c83122b3f2b6b2d590d"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "25a3c4ff800a06814949513f5ff70cffa610af9f49d08b72ee63070c39cc5f4d" => :catalina
    sha256 "c402c0135483f72bfa98f3c53552d5cd9cbf2741e4934ee41451cc8a7cfbd781" => :mojave
    sha256 "051c1842b448fb60b03c8afbdcd2827b94f8dfeab694a2f8a7bb8a438f64fc8d" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
