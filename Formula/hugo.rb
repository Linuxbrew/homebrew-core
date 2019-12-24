# hugo: Build a bottle for Linux
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.62.0.tar.gz"
  sha256 "a7ac323c3ef4300490aa452d03bd1e73e4b013879a8abcf97f278badfaecad46"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "762a5e25d5da7295c76143a0616096b264d2c2b1e68b30d69c57cb4045ce68b5" => :catalina
    sha256 "2b17e44228ad1e8bf7bdc9f2b399bdfd048983287d771f6edf6911864d9b30fb" => :mojave
    sha256 "e94d37b20c3c115f7bfade332502f7cf6a79fa7a3d27d8c78bc2acef5182f61c" => :high_sierra
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
