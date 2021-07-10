class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.4.tar.gz"
  sha256 "eec79d6a08ae395016a0745b5aa2689daa9eac3c7c7f1528c0bc2bc9896d4ae7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7caaebbd331c49118e4bc737617a157e625a72b0d7d3f03494355f7eb1e2457e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8457fe862ff792d1cc142902da27107d0c71999c73109ed2fc2b20dff20d775b"
    sha256 cellar: :any_skip_relocation, catalina:      "3714b280bf2f64d2cd82b5e0cff2e4ec83a18ec36a7b9f57749e6c42a572b359"
    sha256 cellar: :any_skip_relocation, mojave:        "6825dd31a8a8f114cd516befc82137da179c964e48c9a0dce4a0a861d9aec56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b61e6aab196aee0b5c91bfc6d3d15afe5c675735c8383e34b2e32635062755" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
