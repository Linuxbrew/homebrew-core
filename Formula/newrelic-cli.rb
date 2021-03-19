class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.1.tar.gz"
  sha256 "cceabd1467b1a349da5b51c44d1bc6126f2a97c6ba1d0a194afce89d56cec29d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff67ee8dad7a868018cf903959f4a82f671833e43c90f8020f11a04bfae15fae"
    sha256 cellar: :any_skip_relocation, big_sur:       "6818fd3e54a9f820be0d1e2d61f94ee13ef97f6bd14fc8dc3bcf12709d9559aa"
    sha256 cellar: :any_skip_relocation, catalina:      "2f5b184f2e2dd8e4bf84678ae9082fa17fcb800758b0adfa46c555bf56764b4b"
    sha256 cellar: :any_skip_relocation, mojave:        "5ecfce3dc19d394feb705f3eb460cb7a53b898015cff2a8e099a65ee286fa501"
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
