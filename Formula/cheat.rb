# cheat: Build a bottle for Linux
class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.7",
    :revision => "09c29a322f4393f1c92d00b84c867b2c8ff45a7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad5c46d1ec437d364591fc640fc3eaa67f98a379497894bddd2f83436cc0635d" => :catalina
    sha256 "ff93eaa6fdd671e6b490d7ab61bb4770fb045281b047f44033bc4d45d982373c" => :mojave
    sha256 "08d47ee793dc589ac80af88adec9dfebd34f3d04c22db50af7f0c565ec52ffc2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/cheat/cheat"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end
