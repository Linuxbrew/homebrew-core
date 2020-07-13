class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.3.tar.gz"
  sha256 "f178c46b08a6211ed353c2cf625918d582dafce2b76349a0b4c0181c8ff9622b"
  license "MIT"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d723073619c7c2fd4000031f8e62aa870f794117bd98532848077609a8a98e2" => :catalina
    sha256 "ecc1280cfd43109a6f7de135d1dc2997476c78b4736323ae29724433762547b2" => :mojave
    sha256 "d08879854f7231ec647220e05df13f33f5b58865243a0254e318dfdda761db6f" => :high_sierra
    sha256 "2b19cbb7ea71574a7ec5bcfa3d111098ef498f7ca13db8b590aee0e2ede51bb1" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

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
