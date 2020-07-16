class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.0.tar.gz"
  sha256 "66ab895760e10b864ba7451ab2739178152a9b8a982739dd5c5cd685bdd7d220"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "68e940b5fdf57485168b0a773b409d01dabddd86914ca08d98ca4c323760a61a" => :catalina
    sha256 "579d08ee0cdb7b55ab3ec50d986221aa40dd2c583774cc8abc535dcd4031ecfa" => :mojave
    sha256 "1d30487108425b5fc7f5af86974ad97121a0c456843ab0693b737aa11f131bf0" => :high_sierra
    sha256 "1e790e000dc9b2d5de6b319cda133b3350d3f0ecdd9027de94add3428d00da94" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
