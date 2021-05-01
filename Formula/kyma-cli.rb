class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.21.1.tar.gz"
  sha256 "f5177b73aa49dc28e14fc47ec1fb654a1dd5da41ea0676d11a35983a17e0e2e3"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "acf6f85bd672790b023a5c79fb92b44b1521e694d940d3c425dd3d365bf3b5c9"
    sha256 cellar: :any_skip_relocation, catalina:     "9577f3d654e61c6380ae7be8958a3b3677f37d068107353796a30774b32af0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28c912b6cff7d07be16c231366cf90eb3b8e821a750bf27bdaccc525dd1684ad"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
