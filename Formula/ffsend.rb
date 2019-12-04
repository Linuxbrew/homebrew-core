# ffsend: Build a bottle for Linux
class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.56.tar.gz"
  sha256 "51f2e403e0bddc79b3eee71ed31f9c0007304a6838ef6ab67d8b3052db011cce"

  bottle do
    cellar :any
    sha256 "9f1061f01c718c09b762f3f2ebddcf1cd27d372bb282d744285db348ea6893f3" => :catalina
    sha256 "4ec7aab812416c1e262d7c4077c0fe3f39a51255e69e16bd938dce6d53420a84" => :mojave
    sha256 "a2287e34971ae110e2ecc0ec3c23fc9626861c250bf00ba48b558f4a550174af" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
