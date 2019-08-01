class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.6.tar.gz"
  sha256 "f157a1ada813eb643ddd9a60a0efe3158f1da25b1d11bc1ef6c7fa219d4b23bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e347596a83f169bdb0b72cd81d69ea275966fead97f7decb67c873380c179b8" => :mojave
    sha256 "4ec52d9626abcbb07f25640c9ecec4e620faa9ee619f6f289f172aa7bc509590" => :high_sierra
    sha256 "e0e8c356eb1ed32cf074d4abfa81fd8fa9d6d8dfb7c7724c696a521f974a3b44" => :sierra
    sha256 "ed1a7016131c7d1f134337a26d72a57750054d816159efd37354614b8f68b9e7" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"statik", "-src", OS.mac? ? "/Library/Fonts/STIXGeneral.otf" : "/bin/ls"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
