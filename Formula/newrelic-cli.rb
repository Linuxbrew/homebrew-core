class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.10.0.tar.gz"
  sha256 "612f3328d8327345a59e801104e037ee8f824417ea4591bd742d81baa3b64c20"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8538e04f0ce509ad5d7eb7c26980ec4b2f0137b877d7d5b6938cbc1b4964c8aa" => :catalina
    sha256 "51cad2fac2d69d7f374db8040e29c45c13f3f8ee30679ad5d74a76fc058366c0" => :mojave
    sha256 "2146e9d28d8738b2381b8566dfc1407655b60de1fe6cf0ba235ba8928492a539" => :high_sierra
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
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
