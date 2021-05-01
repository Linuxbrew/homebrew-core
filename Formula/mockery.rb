class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.7.4.tar.gz"
  sha256 "22297f811490d4eac93f26b129ed3b58a9d5b42893496a32acce0b4756676870"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8800172f0f5a79fbb3e0993126313a269844b91bd02c57576c85aeffd2f22e5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8067f6c4b60902b0c4f1295889f318ff6f5ff7bc88696f825921948728df5ff4"
    sha256 cellar: :any_skip_relocation, catalina:      "d773da6f15148f639d91e555c1135be6a25973adf7602d8a8c8d34e4d08faa89"
    sha256 cellar: :any_skip_relocation, mojave:        "3f451f3c8f14796bc4fc526c287667ee1de9578a078837ee1cfe7c98a219b68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e96fcc7ad01e782a4f35d428e7446ad396fd74b32fa73bd3af1c02e9995e55c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
