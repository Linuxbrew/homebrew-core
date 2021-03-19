class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.21.1.tar.gz"
  sha256 "0c76bd22e0891f4073b73d16fe233ab704fe5c0cf539f091d20d2e43ccbc5a1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "336d97f3367bc86fb70d1d686c8cd7e88fe5a5825f66135fda8163cdc12a0314"
    sha256 cellar: :any_skip_relocation, big_sur:       "e89c1faf24d0d7ab8b48653edf4c1bb62df9e24112ff790370a8b43fcd136ffe"
    sha256 cellar: :any_skip_relocation, catalina:      "1ed62a48deacae7016bf9a9245e5d0f0435167e5fd02dd8c0031ceb0bff8e239"
    sha256 cellar: :any_skip_relocation, mojave:        "3544a27377c5bccf5e375dea2a24429c76406bdf8fcdcc9862f522be54439e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862e9c88404c94d743f4893c63787bf2f1399d66cf8972498cef044feaa7c605"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/hcloud"

    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
