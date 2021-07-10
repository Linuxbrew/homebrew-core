class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.52.0.tar.gz"
  sha256 "933ea49489bfe77599f3b1b6981250c0e341c11ff293bcf9818644803726506f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "738955bb8364fefd0acc8ede9b947c8b3fb0cd5d3cffe7632a3d1df45027261b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5379ec22891dc0b59fad157930cdf06cd25373df7cc21b32aa5afc455a7b6d5d"
    sha256 cellar: :any_skip_relocation, catalina:      "c63b03ff49f4da13f1fcf7fcfc27c915ea102fd613446be05aa886723d5b0d7d"
    sha256 cellar: :any_skip_relocation, mojave:        "524b636a5c49187945d811d7b97f162205251b65aeac173618d57e70c30e4145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd4a312a67ffc1f1e1808da824594947cd6e2c85a8ba4502d2ccbfc027bb54b" # linuxbrew-core
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/vmware-tanzu/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    system "go", "build", "-ldflags",
                   "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}",
                   *std_go_args
    prefix.install_metafiles
  end

  test do
    resources.each { |r| r.verify_download_integrity(r.fetch) }
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "all tests",
      shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
  end
end
