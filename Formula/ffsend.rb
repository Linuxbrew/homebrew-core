class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.62.tar.gz"
  sha256 "3e227caa98fbc5dcfef10f5ade375f4f12b6cb1a00f6e80cd791da32686cce46"

  bottle do
    cellar :any
    sha256 "cf377cc652f4ba62a994c8897a26f1d8a322f02687c576678989a61c8bdebfaa" => :catalina
    sha256 "691196b9bba712b9204f1a62006e81df3cd375ad6dd786a1cbf50d404aa8b673" => :mojave
    sha256 "67e7f03d9d883ac5fa217309cd9fa1ebf08f836e4f6009987e110ef60b6bce4d" => :high_sierra
  end

  depends_on "rust" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
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
