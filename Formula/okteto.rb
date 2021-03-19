class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.5.tar.gz"
  sha256 "a5ab37aae2ed7b0d3d257ec2594667fb626b341931c7a040d008d542b6fb1c9d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cbe6a581db6cf3f4e047b778b14847dd429d8f12253ad4c1af0aa64c6bba6492"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a66b1429eb63bb231fef560f3b1c7616580682c766dfd3b62b3454db3a68dd1"
    sha256 cellar: :any_skip_relocation, catalina:      "5868d70caaea5b0a8169f1afc4bb5297575ebfa80eeff4a5b637b2879f626364"
    sha256 cellar: :any_skip_relocation, mojave:        "309fcd1355f601320d5bbb4372251cb2ccb88b874385d4a4865cd59bcce0ce1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13e7b535c6f5706cbf4b161f24379fb70cebab27c68f790effd7d396dbe92d4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
