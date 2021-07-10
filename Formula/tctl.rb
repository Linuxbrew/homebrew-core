class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.5.tar.gz"
  sha256 "da8279e8ac5945ddbfbfec9dbefef8d99ac911dc37fc97cf725316239512c72f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05902b14ed5faf7ee929ea6ea6cbf7ad2d23ca162a8e2d9a229e0a6762246068"
    sha256 cellar: :any_skip_relocation, big_sur:       "9593a16cc39a5c9476960741ae568020c01fa1e2388cb31f1bf7e225fd7abe46"
    sha256 cellar: :any_skip_relocation, catalina:      "943c03263bb52032517ad7b290bd0391961a48c2ddc1a5ec8edf083f241d9adb"
    sha256 cellar: :any_skip_relocation, mojave:        "8306eb33ac17c37e6fc106f5c842e7762a22c6eb1e322487b7264d170bdb4953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454213c37aace0883788b01202be30481266b86c2cc1bb04a7eaf7cc6cc451db" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tools/cli/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/tools/cli/plugins/authorization/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
