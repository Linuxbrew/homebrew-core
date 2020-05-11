class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.2.0.tar.gz"
  sha256 "6d5afb54b6c94b8de46e629ca84acb3fcb1f5ac1f80d3ffa1b1d4b3dba837d6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "32f7ec916a1be6e6c506a9236190da5ba45fa10b032c21e3f4ac517ee70d5841" => :catalina
    sha256 "f6fdf5cbcc1eea14019f137c750e5d9234c1ae8281c6d1554926519f6cbedc3a" => :mojave
    sha256 "779c1e4d33d3d53d01b0fa307496e5ed39ab53eda8195f75aeb5794628f80556" => :high_sierra
    sha256 "138c1b6907517c9b118cf1a54c0cf3c5b09cd6d876088f0a46d54f8b480a050c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    flags = "-X main.version=#{version} -s -w"
    system "go", "build", "-ldflags=#{flags}", "-o", "#{bin}/#{name}"
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
    assert_match("✖ 0 errors, 1 warning and 0 suggestions in 1 file.", output)
  end
end
