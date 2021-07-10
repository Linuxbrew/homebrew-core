class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.22.0",
      revision: "a03fbcf166e6f74ef224d4a63be4277d017bb62e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1ea963733dda06b43df6c1b34b87c4365ee055ce01cca8eb8bf90f2a7904468"
    sha256 cellar: :any_skip_relocation, big_sur:       "476bb6663d4bd767e914c24b8c72cdbf3c12641aab6ac8fa59adb6b56cbe91f7"
    sha256 cellar: :any_skip_relocation, catalina:      "5d3c3706be8d9f71cb9505fb10abb239a8dc491b68ef803030a83d431f1b1113"
    sha256 cellar: :any_skip_relocation, mojave:        "b56e75f3f8c29eef6457c7c0d01eceb6623c5630f63f5fd2d3277cf40e08a016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11c92052beb48e9abae34375490cc48f84b8293969410df6923d01d3b6c2e22" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
    (fish_completion/"minikube.fish").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
