class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.18.0.tar.gz"
  sha256 "12dfe19d2734a8c8c3bcd4e8e9a43e5ae58cab61cc980b7fe6fe9526e7933074"

  bottle do
    cellar :any_skip_relocation
    sha256 "893af4c7e2bad62e59bfc8ecad812baf7c5630d6b2f9470c620417a9dad8cd06" => :catalina
    sha256 "57bd8645954f7cc0b391820870cd94d69ecd43d28bae19bcbd8fa7229fefd0a3" => :mojave
    sha256 "ffab33f71178f5537604f5b1be6fbed0d522d91414ac839e9c63907199d7d979" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"
  depends_on "libseccomp" unless OS.mac?

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
