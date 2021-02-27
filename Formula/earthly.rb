class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.3.tar.gz"
  sha256 "dc5a4d7978013931422bc2c8b1185f9131a1a07c93623143e5acbb6059662ac1"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa035356c27782a07a0163d2178855e878fbb19ea3fe88a7cf3fcb7210e0cdef"
    sha256 cellar: :any_skip_relocation, big_sur:       "47e4935a2d7f15fb56f23ada7d3cbe0d7b6535ae8a435a7ad0ab0fdbe2f61a98"
    sha256 cellar: :any_skip_relocation, catalina:      "8e08ead2e116fdd1045fcad5ffb540e1789de4de7616dd80ab70b3ed621598ee"
    sha256 cellar: :any_skip_relocation, mojave:        "5ade4fab3501ac735435c530b2c094bc7c7f6e411f9b0ca2bb087ecbd057a3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29cb57d521fdc626ce0f90c375feab19d2fadc64c649f86b4ae8b9d60415fcd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=d4845a524e822b12803da1b11c23664709e7f44d "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
