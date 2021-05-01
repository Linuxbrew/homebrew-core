class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.6.2",
      revision: "b131ca8ec77c96b9898470eba9560c30af0f23f3"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f769aa66b8f7eaecd187da23b1b51d011107c963298151e173c7c1d605541480"
    sha256 cellar: :any_skip_relocation, big_sur:       "73cc28162f8d5b9895444bf3652936d39f8c462592b181b5653ab9948b2125eb"
    sha256 cellar: :any_skip_relocation, catalina:      "8e472b581f42efb6009e822772f363eb98dd9e2f925a2322705a2241525ff039"
    sha256 cellar: :any_skip_relocation, mojave:        "75808bc1c5a94715dcd4fbd47419e264bc722d8038f28ee331a72f2d8d75b8cd"
    sha256                               x86_64_linux:  "689ddb5d808025059b77af748ca5da8e69123a834fef8a0c2bda9e0b75045a24"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
