class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.70.0.tar.gz"
  sha256 "4d1df7a7fbd91706dbf3d83f250230cfdcc2076cc0dcb4147971f80add2ee751"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54c6aaa51621d77fce465ecf25bbceaca85ab63ce61be59af677f7d31266bbd0" => :catalina
    sha256 "660b8e9de211d15cd72eed01be152a25d8e3124ce75d8a36e8a33e373d3154c6" => :mojave
    sha256 "41c80417cc491a4b1e2a2bea6d2187783f2f66245aa65a544a571bb68d6f3cbe" => :high_sierra
    sha256 "768ea44d28fdd9eb0a9f2eb04e5bbd929bd9b1707863efc8d9a72f5c68fdac01" => :x86_64_linux
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
