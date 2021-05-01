class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.35.0",
      revision: "b33b2f2b21695c8406aa582c216b107e56b86ed9"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3341f9ddd5ebef42bc3a05e9c612209a8e6e76feb4e1fc8883f9a505be655132"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae3e1d5c2b8550cb88eaaab3ac503af6653cd291e13b966e9225091233d2937a"
    sha256 cellar: :any_skip_relocation, catalina:      "111de5fe1414ad65e2c613437194e0f03ab0d61aed91a1cd98d49a2363c84b66"
    sha256 cellar: :any_skip_relocation, mojave:        "6d23d14fbfede9fb74462c6d3a64a43d2a8e70e46ac4270b52da960957d5943b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715ad5d076a00a4c77e6a0feebcec9b54693915575b2092bc55e1a026e43f874"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.git_head
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "bash")
      (bash_completion/"mmctl").write output
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
