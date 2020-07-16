class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v1.4.5",
      :revision => "e49ca13453752e0577a665e7410a05ab48b41fbc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0b72d11d266414f66d4c2c3a9ac4aec96598d0ec47ae7c1f87e779de227713" => :catalina
    sha256 "0c281bcb0eef8b491149506dd1fbed9b748776e6cef6a9f137d866c41e80d658" => :mojave
    sha256 "ed9fcd4630eaf89f2b7fdf1f0e0b9cd01e3f3ed549c6a4b128364dbf5de71792" => :high_sierra
    sha256 "9f7f9bb53f950134f500f23355038fe03fcaa158cda3269602c72d17acfec74d" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
