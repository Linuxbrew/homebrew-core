# goreman: Build a bottle for Linux
class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.5.tar.gz"
  sha256 "ceae7f2b71098799982928f35174df91e301fd5792af12b97a9ece943d260b9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a589e79d6ffce2ca28ebe5a7d8ba78513e807edc92f43a042b684e2ff98eb1c" => :catalina
    sha256 "fb6f2fa697b73522e1a49144492d59b1546a886f3bd048b8740f6a76237e8eb9" => :mojave
    sha256 "7aea9ac52394e2ccb260a47c4c27f874db26ccf5136d9488dd7260ab15bcebdf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/mattn/goreman"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"goreman"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
