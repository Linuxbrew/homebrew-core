# kops: Build a bottle for Linux
class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.14.1.tar.gz"
  sha256 "11672b169d833f0c8c5c43035f916a5b958e09ac2e000fd57be53ddadc37b38e"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4c4e6535c4386370a2641ba9f2174eff87785991c1ac7485d96098cae852fec" => :catalina
    sha256 "48447774e75263f14051f575c9abc1c2840d25295610fe7b6b49b35ef1ba7fde" => :mojave
    sha256 "54d050a6120dcbae505f02775304948bd71a85f57719cfade4336e18e3f87f5f" => :high_sierra
  end

  depends_on "go@1.12" => :build
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
