class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.31.tar.gz"
  sha256 "9ff08a33f5c69bef8901db539af8468b59dfa7f7a8f0b99ce8bea0e0e25cb1e0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca25c872a2dbeaccf653804615bfebc9734e63e49352311bb7ffe9e72a53edf3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c0c5516627e2c88cfa6eb1846c3123565aef987217f239083faa1d0b8d3131f"
    sha256 cellar: :any_skip_relocation, catalina:      "e4517a25935c5f142fdde7c0ba55a359280401695eb09d1efa35a76e1ea8518f"
    sha256 cellar: :any_skip_relocation, mojave:        "96b11b22190fdb92bf3655f5734a9ecaf884ff546c786bd9df5097a3ef3ce60d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
