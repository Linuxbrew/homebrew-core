class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.2.tar.gz"
  sha256 "1eb665522e302e8025ea8abc9f9e62d04c3e0518e406ab013100d2364b92c94e"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "838b6aa8ad50514f9191f238920e073976453c4e01d5f350bc1a7ae69b1c1861" => :catalina
    sha256 "e0b1462795554b28045fa7bd9e00702e6e8b13bd4169e0545feb01da9127b31f" => :mojave
    sha256 "81ce10e69f44f46f758137c3f154d4faec574e4f34b32327a1962fe8ad8c61de" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
