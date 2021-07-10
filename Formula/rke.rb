class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.9.tar.gz"
  sha256 "958f1be715be516bc782896d6d77b0665054ec6545f94d1b423f24edec1a77f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c673c76ac1f6228f2efce19a547178e02695779c99471cb804d9475969f319b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "46b14a501ff279fe76d374385c21e642f035d242fd1adb32ad8012b8f179c7b1"
    sha256 cellar: :any_skip_relocation, catalina:      "87c8b3a81aeb17e12d6acbc0df6ddf22eb6928e559662504aa45dc3241e63dfa"
    sha256 cellar: :any_skip_relocation, mojave:        "595ab8255201b2e20a3f4e1e01586c4d6120783a69471da22c3715fbf5f5d5a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b1f502196bdae7f3cc9ce95452a95600c645b841e0de139420909e6c07ce056" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
