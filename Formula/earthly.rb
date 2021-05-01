class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.5.11.tar.gz"
  sha256 "1584495fd8dfa3839f36286fa16bdb611151773033a5e6b936a5df9836c5b06b"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d997f63c1c1f59d4f87d692115d817fcc47bba548489aafd49b5ae2670cd90d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd9fb8d49cabf534ec2d116d89eb3bdeb6b903ee03edc96052481dd984f5c4ba"
    sha256 cellar: :any_skip_relocation, catalina:      "90ea7724fa1ba7761ecb35a2c0ea09891966c61fd61416cef57a41c1c2db104b"
    sha256 cellar: :any_skip_relocation, mojave:        "28908c28b5f5b2f128a04f4d1caceb0ab8fc1b9f2007f09a9af32fea02dc564c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27faaf42cd5c3c4223cf6b8ffb47fdecd5eef649953473016b477948260e26e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=4441aa72487b448d1a3e94cb0ae6afc1ad02ce96 "
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
