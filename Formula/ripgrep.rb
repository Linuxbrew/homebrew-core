class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/12.0.1.tar.gz"
  sha256 "5be34aa77a36ac9d8f1297a0d97069e4653e03f61c67d192cee32944cd2b6329"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "61b5686741206e584aa2f94746ecdd68bea29ad381b2a6c0ce2076cacb8408ca" => :catalina
    sha256 "1203664c55ee33d9b668cc9e8f4fe06b2cfe48ae7bc1374b3576104defc279ac" => :mojave
    sha256 "7a0ff676fe9bfc33f3c4279856c45238e3cc61a396cbd5e266d23796a5003e72" => :high_sierra
  end

  # Dependencies for man page
  if OS.mac?
    depends_on "asciidoc" => :build
    depends_on "docbook-xsl" => :build
  end
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", ".",
                               "--features", "pcre2"

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    # No man page gets built on Linux:
    man1.install "#{out_dir}/rg.1" if OS.mac?
    bash_completion.install "#{out_dir}/rg.bash"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
