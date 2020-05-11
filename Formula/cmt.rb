require "language/haskell"

class Cmt < Formula
  include Language::Haskell::Cabal

  desc "Write consistent git commit messages based on a custom template"
  homepage "https://github.com/smallhadroncollider/cmt"
  url "https://github.com/smallhadroncollider/cmt/archive/0.7.1.tar.gz"
  sha256 "364faaf5f44544f952b511be184a724e2011fba8f0f88fdfc05fef6985dd32f6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5ef577014cea6d1ca60ece5686461755e83bdb5134e696f0769ab46bafecb740" => :catalina
    sha256 "de80bda11c02f8abaa16357a8c2d796370b04012d6bbd6af3ac9d6c5e43f14f0" => :mojave
    sha256 "afef38c021fa48504acb547a5c0006e2a50c59fdd69a88b3eb9d279c8aea496d" => :high_sierra
    sha256 "6e59e8ec8b4b175d5edca321dbb86b4ee7b44fbdde4b040f38fd6752e7faf1e7" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/".cmt").write <<~EOS
      {}

      Homebrew Test: ${*}
    EOS

    expected = <<~EOS
      *** Result ***

      Homebrew Test: Blah blah blah


      run: cmt --prev to commit
    EOS

    assert_match expected, shell_output("#{bin}/cmt --dry-run --no-color 'Blah blah blah'")
  end
end
