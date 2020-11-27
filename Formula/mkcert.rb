class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.3.tar.gz"
  sha256 "eaaf25bf7f6e047dc4da4533cdd5780c143a34f076f3a8096c570ac75a9225d9"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae4b584f5408d6b17b164fa002c2385ec7ca285f10d832f78b2230ae7b79ed3" => :big_sur
    sha256 "f53f22e6ddf746c4efb7f8c3c595f143fb60b2134d4cd18976650bd0ad9748ff" => :catalina
    sha256 "20c5690b998ab1af2ca387ed84b54dcab9488e031538563704fd02c7dcee3589" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/FiloSottile/mkcert").install buildpath.children

    cd "src/github.com/FiloSottile/mkcert" do
      system "go", "build", "-o", bin/"mkcert", "-ldflags", "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_predicate testpath/"brew.test.pem", :exist?
    assert_predicate testpath/"brew.test-key.pem", :exist?
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end
