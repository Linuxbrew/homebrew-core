class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.4.1.tar.gz"
  sha256 "556a8e70dfbceab02ca59afdd97549da4cdc00e1b006982fbdeee446fdae0562"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ea54d34460a33b285ca8494ed0541ac8b82af208c54a47ec53d77920754bada"
    sha256 cellar: :any_skip_relocation, big_sur:       "91575e5943be424c2f409b853624781dce463f7eaa5868bbe4535874b20ab559"
    sha256 cellar: :any_skip_relocation, catalina:      "934abf7abbce2a1ef1650652049c641229b39ea152a79e6b5c798daaf9574705"
    sha256 cellar: :any_skip_relocation, mojave:        "1563ed86517a0ed586586d24d0fc48dd28d7ea28daff7fd30ae2c886429d53ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f66e3d61667d8df49e78dbbaf6cb1a0f8b062d0331207e5dfcf500f6b33889" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
