class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.6.2",
      revision: "ee407bdf364942bcb8e8c665f82e15aa28009b71"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "449dee347b17a3d23c91446ba928174cf3017a61a3fa940631af9fb5d64a25f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd6be8f1be7a5c70d2e405661ad113329b4bee963761913d6d86d66858b410a1"
    sha256 cellar: :any_skip_relocation, catalina:      "2952ac5a7616cde0fdb055a8d3cc1e5d7895134689c7f49c064b32eedcc72d9a"
    sha256 cellar: :any_skip_relocation, mojave:        "6f08477f73cbe14ec64701ad5813f76937f042e61252f7bc5fc3baf1c371e720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e49b19ffa7ebec22364699829cb20fc582ab613badace7bd9f1d5f3692ee230" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
