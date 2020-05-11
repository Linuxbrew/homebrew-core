class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.10.1.tar.gz"
  sha256 "2488e9b86980ce5f9b009998afe663163b7a337c258981ddbe52d79687442434"

  bottle do
    cellar :any_skip_relocation
    sha256 "495d6ff17938caf29a6fde833a3a83d66828ef8a88d67961d7768e9f096d069d" => :catalina
    sha256 "48bb47eb4144fc257f24d376a157cb2cb2bd001fdc0d4da649313d8ae9f41469" => :mojave
    sha256 "16a5cc7f704afa4835705a612fa2e0d44d4bb642e8b82c375d2736d94662806c" => :high_sierra
    sha256 "d3c1205df10e7f44f845931541fabba1816ee0fbe348d487816ee4f3355f41eb" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "meilisearch-http"
  end

  test do
    output = shell_output("#{bin}/meilisearch --version")
    assert_match(/^meilisearch-http [0-9]*[.][0-9]*[.][0-9]*/, output)
  end
end
