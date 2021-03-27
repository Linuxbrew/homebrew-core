class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.14.tar.gz"
  sha256 "d5da5b9bde8eb7721169224e95fc6be68a8348f17cf9b9a7ee77a338ef516544"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b37898a603be618c0cfdc9527e641e7cb0a31aee94fda85a1be29f4c67625ee3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3dc707bc8eebd301aa8da39b17d644d30f8dfaca592521232a4b98fff935afdf"
    sha256 cellar: :any_skip_relocation, catalina:      "84d195a6a3b6dbe5032782558c029fa6d2c6aa34805b5ff5d86cfaba25e7b243"
    sha256 cellar: :any_skip_relocation, mojave:        "de65463d314c3b99b9c5948300949f11997540140982ef86f51e26155b340862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65a153d220734aa82e50b81bf4c20ed42e765ea9759be324a2cf012812e9b72"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    assert_no_match(/WARNING/, good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
