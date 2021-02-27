class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.1.6",
      revision: "7c3498b1d29a00b361ed10410f61fb4b520ab050"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2aab81f7115f3725e5851992a65ed9fa39992f832892f0fb7d492120c2e2faf6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6bbb2c55698625e0041882a6c65c3f0d7563a5dc56f62c6dd890332bfbb7d231"
    sha256 cellar: :any_skip_relocation, catalina:      "256a99a3132845256264b64d00a97fbfd73038937e4a7dc6c3c68267c44fe4ab"
    sha256 cellar: :any_skip_relocation, mojave:        "75da23cd93ce4f91c964835997b3d8d10439c1420b0333db8f8b0b52432e4c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d3e73a5a76480795c7208e6d734e6d231d8f1963fcd63a2bdbab77402e76b7"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
