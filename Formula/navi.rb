class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.7.1.tar.gz"
  sha256 "e14bc6ebcf2c9071c1b437f77b88da2a70d1616dedf2174589967eb4aec20acc"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "57c4e06c10c8c3b0bd7675e538145708316314113bfa178de0fcb83aa7f44b5f" => :catalina
    sha256 "c33831c2ebbe20a6bf2754521dad5d4b99c3b40913866a1814bfca10f0a35423" => :mojave
    sha256 "48bb12b04cefc5be0521b88a0bea9fdf5a1996c9a6b237d77ea9d3c11278429a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
