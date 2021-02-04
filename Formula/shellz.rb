class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.5.0.tar.gz"
  sha256 "870bcc2d6e4fd20913556f95325bc3e1876f3243ef67295c33e2bcc990126e97"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "901aa899dffdce56b40da9b622acd01acb15103cbae6d06cb35320fc85ffa626"
    sha256 cellar: :any_skip_relocation, catalina:     "1c1eabfee3228f25f75b4838f3d0a8a49e84c87eb2926e78cdf05dff094aa0e8"
    sha256 cellar: :any_skip_relocation, mojave:       "aa5043471c26fba80ba9db128f5ff3e8b60051bd76a8d26c3ad114b59b24c8b3"
    sha256 cellar: :any_skip_relocation, high_sierra:  "83b7e5e52243efe75e302853574243667a8e9cf9899d480c12c27886e77a9788"
    sha256 cellar: :any_skip_relocation, sierra:       "b659a90bd79e516d71679e68d36a35038937f23ee9d1de1dfee313fd11b0169e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "846d5d66e131e82db999e636a7a807a2a1116a5ae947630d15a9c59cc2aed966"
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/evilsocket/shellz").install buildpath.children

    cd "src/github.com/evilsocket/shellz" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "shellz"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
