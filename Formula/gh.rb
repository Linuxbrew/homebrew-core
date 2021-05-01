class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.9.2.tar.gz"
  sha256 "a1d5a326c9311f8d208a0e5b5ba47023c3982494063e34ea10da916f9b8ba5c3"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf12b5bf3ca0ca3b7ca02b21044415d3c089412f1b63210e49923176e6634647"
    sha256 cellar: :any_skip_relocation, big_sur:       "d82df4e2be9ca5c76508c1f55d26be681153de2a99f0df92f2d145b51a15259a"
    sha256 cellar: :any_skip_relocation, catalina:      "0d6c1fbee481e0cde4edbaa38de0ba666636f44bbe07b5b780defc8c51f2a11a"
    sha256 cellar: :any_skip_relocation, mojave:        "7284e6f49adfa2655dd6bb611ef680ad2917d389d0a865398669ca98f0e7ca1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52cc4ae02df420d8b8ca654a7e6788d30c459b96d6c1e4722b2702937ea03a0"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
