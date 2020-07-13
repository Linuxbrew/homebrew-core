class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.4.0.tar.gz"
  sha256 "f9ff00839fde70bc9b5024bae9a51d8b00e0bb309c3542ed65be50bb8a13e6a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6d6fbabc41bbef0488161ac1ab71d486dd0439eb8ee3072b1a812cc0d573bee" => :catalina
    sha256 "2d39b261dfa7208c257416d61115c22bf242b16e7d696eb810252c192981a052" => :mojave
    sha256 "40debf4a33e518102e579e8e8dbdefa2676c4bf057cbcb994bb86f05df17dd16" => :high_sierra
    sha256 "9579ef253dfcabe7425aa8a17dd2b97bba86a134787d69cc98fcd932e60a1dff" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/git-town/git-town/src/cmd.version=v7.4.0 "\
           "-X github.com/git-town/git-town/src/cmd.buildDate=2020/07/05"
  end

  test do
    system "git", "init"
    unless OS.mac?
      system "git", "config", "user.email", "you@example.com"
      system "git", "config", "user.name", "Your Name"
    end
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
