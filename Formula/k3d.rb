class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v3.0.0.tar.gz"
  sha256 "939fae09600ae7edb5e92ecab5c25ac2adec5be432c8a7ee34a14e01a0245b11"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "03c91c6c398edbc38868f9814ed7040b9f947627ce208eba7c79051d13773712" => :catalina
    sha256 "155b9526ddc84b8ad21e745c08c73a37b4c47050d137122a52976ddf880c1cf2" => :mojave
    sha256 "a46edd0c310e5daeff2daa5a84fe07a45ea49189e20b1e9856ebf4377f7dcc10" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/v3/version.Version=v#{version}"\
           " -X github.com/rancher/k3d/v3/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output

    prefix.install_metafiles
  end

  test do
    assert_match "k3d version v#{version}\nk3s version latest (default)", shell_output("#{bin}/k3d --version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match output,
      "\x1B\[31mFATA\x1B\[0m\[0000\]\ No\ nodes\ found\ for\ cluster\ '6d6de430dbd8080d690758a4b5d57c86'\ "
  end
end
