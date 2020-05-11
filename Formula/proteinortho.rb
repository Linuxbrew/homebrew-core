class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.16/proteinortho-v6.0.16.tar.gz"
  sha256 "2a076ab2ac1dc525a27e6be61bdc2075587024fd1a4604d8eea4701cbbefc119"

  bottle do
    cellar :any
    sha256 "1a61befd49bbd03a0daaa5d73fa8e10b4a192a1251f1c0f6f6eb42da6184aefc" => :catalina
    sha256 "e2ec6830f00fab4ac8acb829a341c97830cbfa21f2ee6822a1c634bf1cb712bf" => :mojave
    sha256 "44160d14c8a7ff3a5da2c639fc407bf03e25114de7f0fe758d1469ff6fb53b86" => :high_sierra
    sha256 "e037c7162afeb01f632199e239290609747b28bdd37c5c14035429ea06736428" => :x86_64_linux
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
