class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.11.0.tar.gz"
  sha256 "e2137491f269df179ded7066f641ae7879a40870be53170a0388310e904158b0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee4b879f06935d40035318d4189d5c057e53c38c53e5d4e28ec6b458bd98ce22" => :catalina
    sha256 "85cc073f44cbb43bd87e171fa505a770822e4655b5c92c2424d7aeac73fae727" => :mojave
    sha256 "34074c761bd6200fd5d5a61e23434836e487febc0bee3336c93e8a1c4864715a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "make", "bin/gh", "manpages", "GO_LDFLAGS=#{ldflags.join(" ")}"
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
