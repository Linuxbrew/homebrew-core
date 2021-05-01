class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.28.tar.gz"
  sha256 "83d2bda420168fa3729a23943ce53739d3329b7cd03785bd68bcddb299ecb4d7"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ab6454c1b063d26eff405232f40fc57786207c52d233c140d1fd4336419e203"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4f7345456e442572d53bced745c05084fbe9f8d014b2fbbc00052e3b86f362c"
    sha256 cellar: :any_skip_relocation, catalina:      "c6a00510ee9980c98130a84a2fc97884eeef52a1c8d729855661dae7ed798fbf"
    sha256 cellar: :any_skip_relocation, mojave:        "b9be489a7adcc1e9f45cf5ce224f7ed981dcaa95fd445a84dce9bb22a7f06188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2f6930c77536faca1d88ffe3c0d35cfb3592fff51a70ec7ba216cd14834069"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
