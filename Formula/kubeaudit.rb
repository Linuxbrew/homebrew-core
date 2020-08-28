class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.0.tar.gz"
  sha256 "0bba4b1bae6f6161f96049beed6452408195b393622290285569de740409e33a"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35fc84415005e66c1a23211dd1355d5381a3b4bce88255e597c10007cff7a0e2" => :catalina
    sha256 "7badbf49b0ea633508b9131aaf137a731504a77ba1b3df03c59e1fc0b5f228dc" => :mojave
    sha256 "58c2e0a55227d7213b8dd5d47a0c01672c24256b0b631a256c9284b3accd7b1d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
