class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.8",
      revision: "627c38cb360f7a9b6eb5f856c7658838644d1540"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3cd13e4efd4b59faa9dd55086f8124bb515198a73c16edaa7c2a377d5526717"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdf4f0f9efd1195dc7775c51645f145f3d63c05e2993048777544307b4b5315d"
    sha256 cellar: :any_skip_relocation, catalina:      "f2b2a0077a8448cd0fad2e51b6538663f50cf91a16139ec6d3e61570b64dbcf0"
    sha256 cellar: :any_skip_relocation, mojave:        "6d9d395dc4fb4f3c4e85e93863f0f0ddf6527e4e3165da71f7136200005c5de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e252a636251902d96a6675174d53722a51fc81d8c39ce32cae545ddfd6350191"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
