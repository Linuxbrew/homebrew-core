class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.17.0.tar.gz"
  sha256 "dc700e977cc7e1b12b3dd9f12e3ae5276cb710c98dd01f9d336c360f9a605777"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ee3d5d7ebec60115cb0a901495d9d34938a8096839b07a64ee428308e974ab9" => :big_sur
    sha256 "bfa4a2accfa9d6bff270568f3221cf3fc8cdf7b854b2e524f924395dd091dec2" => :catalina
    sha256 "9b50502234b8d207eddc402e7a7c779d35884a9aa6da3628e514ac17bd930ccb" => :mojave
    sha256 "5f475c437b9b7614d50143f2fdd38ecb8ee40be842f655922ad8f7273c2abdd3" => :x86_64_linux
  end

  depends_on "go@1.14" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
