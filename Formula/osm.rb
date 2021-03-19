class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.8.0",
      revision: "279ff38901930eb47b288dd1bb3a12e86fa2c71d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffe6516b7c0618ce6d3c7c138b904c746e4fb3dcb8552a13e588f4ec1124386a"
    sha256 cellar: :any_skip_relocation, big_sur:       "680d242114f9a09815064fcbcc8662379d6cc589e99b0908b8d3f50054f80c68"
    sha256 cellar: :any_skip_relocation, catalina:      "0bebb23435f6f1df3948336f9d0768ce2ed23679d6bf9ebc0b501cf0ddaeb1e1"
    sha256 cellar: :any_skip_relocation, mojave:        "6835edc59e79303d028890ebf124dae9b5153edc630d2518111ac0aeae919682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9687b2a55b4fe89017c94281c3614be8a67a91bcadd6446faecec1f37ee847f6"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
