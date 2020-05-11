class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.6.1.tar.gz"
  sha256 "2d25a5bf62c65418861fc6857e60815d271fcf4f1b5a73170c8761a258c695cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd7432f723f657709bf9dc0fe378de6fc498c012f7e6db32823c3b6e45e41e23" => :catalina
    sha256 "7b12857ae9904c9c7202960655739c374eb8cf07b30aaa7e24f1fe16a8abc18e" => :mojave
    sha256 "ba4f09d3fc9bb35478c6774a1d5f9ed1ded994c22fbce66842c8c38c5cae6f22" => :high_sierra
    sha256 "d4d84c3854a202de28bcd1e9a0c7202d49dc7dc5b5310f86d4c25860d1f87de4" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
