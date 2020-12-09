class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.11.0.tar.gz"
  sha256 "5eb167b3f461c5f3823807b6011e56dc278aa4946bc267a65cdbe993f4fbf09a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "01281af8670dee70c59c7579c306b936f9799fb2bf5c136bd4595758a4b1a174" => :big_sur
    sha256 "dd9db15f719423135955a90425ee7dbc94fd9e78804a59c7e5eabd9c52ee73e3" => :catalina
    sha256 "f0727e9f3d3a970003e9465879f208c446bd05404eba834fb6806aa737022bb8" => :mojave
    sha256 "ce1ff7049d6f2696e4c13f059300d1a088732e00d997e25f5691ca32de3ff77c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-ldflags", "-X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}",
           *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output
  end

  test do
    # Should error out as switch context need kubeconfig
    status_output = shell_output("#{bin}/kubecm switch 2>&1", 1)
    assert_match "Error: open", status_output
  end
end
