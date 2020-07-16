class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.18.6",
      :revision => "dff82dc0de47299ab66c83c626e08b245ab19037"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "edd1688fe0f1d752df1d71e559839e50bf6b6ef78cd03ceac197c079c2465c8e" => :catalina
    sha256 "f0da1d2a1f7bd4d687055aca461785107185b86e69dab008fc76dcf3d6cec170" => :mojave
    sha256 "9e7cb0b726f65efa71868ce23541fefde252715fcfd36679f9fd0cb6bb0d411b" => :high_sierra
    sha256 "0d57233ff04722ef5b61790482d9fcad7d91dc9f64c2d67a6ee67cae038d1b20" => :x86_64_linux
  end

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_linux do
    depends_on "rsync" => :build
  end

  def install
    ENV["GOPATH"] = buildpath
    os = OS.linux? ? "linux" : "darwin"
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OS X Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/#{os}/amd64/kubectl"

      # Install bash completion
      output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "zsh")
      (zsh_completion/"_kubectl").write output

      prefix.install_metafiles

      # Install man pages
      # Leave this step for the end as this dirties the git tree
      system "hack/generate-docs.sh"
      man1.install Dir["docs/man/man1/*.1"]
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
