class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.7.tar.gz"
  sha256 "036685d39397c89c946057ac2e333f157ac460f5251413f1db8629cb7462b58a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d68babfb2e3258b8d9859d502427a433312a8dd7d2262d707bb225abb76318b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffcaa4fc81f9f667301178f3c649785586af8befa82b39de9deffcbbbb175ea1"
    sha256 cellar: :any_skip_relocation, catalina:      "c6cdc867a38476d3dd11a3aa863cc08a38889551bcea8e3fdcde1e4e310c32fa"
    sha256 cellar: :any_skip_relocation, mojave:        "4bcf06a1c690c414ff71b5624c6d505021cd88f2908e07ab4caa1306dd0a3b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a85f8499530980e40c301dd177d76530b27b88b0769306517e3740c0fcda00b" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/v#{version.major}/version.Version=v#{version}"\
                       " -X github.com/rancher/k3d/v#{version.major}/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "fish")
    (fish_completion/"k3d.fish").write output
  end

  test do
    assert_match "k3d version v#{version}\nk3s version latest (default)", shell_output("#{bin}/k3d --version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
