# minikube: Build a bottle for Linux
class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.5.1",
      :revision => "4df684c4cc2bd9dc9979cd5dbb44bdfa410850b4"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dfc990444ca996045d1e8838cb040e2c92fc8860c680c7425812f0391e3f179" => :catalina
    sha256 "150aacbaa94da711d2307c1093d0194172bb152695c55ec793d7fbada66a474f" => :mojave
    sha256 "758464faac202b91cdef60c301ea90e4e3fb62df3476d276269dde554df13717" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.popen_read("#{bin}/minikube completion bash")
    (bash_completion/"minikube").write output

    output = Utils.popen_read("#{bin}/minikube completion zsh")
    (zsh_completion/"_minikube").write output
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
