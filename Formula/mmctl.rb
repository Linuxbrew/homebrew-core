class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.31.0",
      revision: "689bd041b5aa02183721fda0c4e9a4e3d84fab15"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "721438192923535b1a0d1af45bea885c48ee21ad1a39d22519c1a98c37eb8c81" => :big_sur
    sha256 "77ed293627e135ce9a6fc8ed77f4781b09b04920735dc81b961de3b4f054ab37" => :arm64_big_sur
    sha256 "fa783633ae2b76697b720868db53ad68ccd394cd1fc35c59e8b65fa38d7a32da" => :catalina
    sha256 "77a2d30d20b3476022a223bc471833710f43034d92eff9b74a50e552dda504dd" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
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
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
