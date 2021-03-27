class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.1.tar.gz"
  sha256 "0a6063e7f7be26185c4550b8d502f8a4d5e611a93ed30b588e727d9b6b7bac78"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d754232e4c9ba6e2704450f42f180f5776d4ccb0e5c7dfdd6926977493e69410"
    sha256 cellar: :any_skip_relocation, big_sur:       "9048b3a4f91c9d67141cbcfc40172eedab6368f6e1f9833d417d4cfae111a7b5"
    sha256 cellar: :any_skip_relocation, catalina:      "d1bbea1d6e8120ad7b510c8763cd40b16be4d1fbed9b9fb4d605a358d2ed1aad"
    sha256 cellar: :any_skip_relocation, mojave:        "11043dba4c04b617f742c7f5c8c5328e2d7e3afc6ed963b29182d1920b96f030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb0e0ba850810e6d8aa69ec71e9134c8d8c5773f2e0c85cfba5790a7d3bee25"
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
