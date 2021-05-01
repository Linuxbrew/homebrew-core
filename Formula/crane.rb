class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.5.0.tar.gz"
  sha256 "106af414bd6eb60f190bd2363d63f84c4f107365f34395e5827d03b6ba8717ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "581781712828260aba980e48180c017aa8ce251b0873e673bdd562e8a8d968ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4d9827390cbea19f3606d87ee65282304c6ed5e8c0efcba894f84b1d3d05873"
    sha256 cellar: :any_skip_relocation, catalina:      "7ce4b31487f73180225c6884f172b1f7b513bc381729624308de28f99cd7110b"
    sha256 cellar: :any_skip_relocation, mojave:        "c2a41d226e4590cff7067e040d7753f5604bf824079bea66bd7a494f87ddb2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88784ecc029c37d52e5ef060204b92d62a780cb019f100bae13c22889a770e68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}",
      "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
