# kepubify: Build a bottle for Linux
class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.0.0.tar.gz"
  sha256 "1207fa20b230f7cb178e8114eda90edea7728a8014f7c7a86c46a4b4bfb4d87d"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b605eabed48fddc8b91aa7926c5d6891cebfbec695e1de9db7ea68f35e8030" => :catalina
    sha256 "47d64ec643746a75899b51f1e14bc1a3d78a6a5d409e26995117a81a26bd4425" => :mojave
    sha256 "938a7cc8a66691e06f9ac28b8f5fcde7ff92149076e9d17c1e1e984322003eea" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", "-o", bin/"kepubify",
                 "-ldflags", ldflags

    system "go", "build", "-o", bin/"covergen",
                 "-ldflags", ldflags, "./covergen"

    system "go", "build", "-o", bin/"seriesmeta",
                 "-ldflags", ldflags, "./seriesmeta"

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
