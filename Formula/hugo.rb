class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.83.0.tar.gz"
  sha256 "c22bbbf4f3e12bced1b6b73ed1b31f45b9123c3d37ccacf2d899c06aa07550a9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a0a852773e300ece042a8b9d9206ebd028b4a263f0a76d35a0e89fc56789a34"
    sha256 cellar: :any_skip_relocation, big_sur:       "9473f8699af407803d794ab114b47b548acf1d1ff4f0d3783874f34fc824593f"
    sha256 cellar: :any_skip_relocation, catalina:      "27a4ad03355da931138f0b1264b5f18b36f48577c6eaab702a798e040aaeb14d"
    sha256 cellar: :any_skip_relocation, mojave:        "22df09979dfdbd52e9a5bbd06eb9e58d9a2cf70f7d8b6ec5029acf687f9a09f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17576493867cf6596c349a0a913dd5f11f9040fe42115e2c205785d6071f7b78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
