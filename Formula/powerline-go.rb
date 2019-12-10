# powerline-go: Build a bottle for Linux
class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.13.0.tar.gz"
  sha256 "0c0d8a2aca578391edc0120f6cbb61f9ef5571190c07a978932348b0489d00ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b6be73fc466b480d6f4fdeb318dec5ce57e5a9d693a57674ca5aa5cd04a7fb" => :catalina
    sha256 "cd2f20c1bd8504a5eb449c482b9d34ada5a5d59c1ffb17173e18c7afbebb3be8" => :mojave
    sha256 "d67e92a591c74edc03a01158672801a8844256c3a078de7c93c317fadcd16d39" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    system "#{bin}/#{name}"
  end
end
