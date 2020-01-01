# hugo: Build a bottle for Linux
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.62.1.tar.gz"
  sha256 "9104642760f071b0a1a06ee7c051cae6725ebaf28a16de577b786180d3d8719f"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8403fb6b1be7a10308a4ca642c63ab59e1e7154587f9d428f2b128d669507e" => :catalina
    sha256 "a24f952027623f23fc2156a91cb599b08d5820791c4ce16264290956836e793b" => :mojave
    sha256 "85872e14e0e7d2f6316466c2f76ac167cef71592559b09069e101bb9ba83d2b7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
