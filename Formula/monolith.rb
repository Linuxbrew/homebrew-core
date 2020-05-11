class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.4.tar.gz"
  sha256 "b2604ee58c5b81cf01f01f8984cd2ff80c5ec56d93aa1131ee6ff88b95767af8"

  bottle do
    cellar :any_skip_relocation
    sha256 "893d62f1c056a612894b20910fb36084f1efb0725e2ec8493a424627763605e8" => :catalina
    sha256 "faa70722d9caa97b445005b56f9fe7af023db7c939816e140d6b62c16ef5ae53" => :mojave
    sha256 "08b0343da9cf541e91932ca070ef84c3bdc218afb2283acaa2a389a439766a8e" => :high_sierra
    sha256 "a8cfd223e0d1ca8ea142c578262fcc0814a514742cc90dd9742b3591036901cd" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
