class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.8.0",
      :revision => "0a318dc9335a1e7cc24c5b19b5aa383ec619f9c4"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbc8ef9d3568b5a7699b80e840e1f452fed74c8464f58c3b79d3d59e12aaf043" => :catalina
    sha256 "bf3198a7432c86a22c2bc12620ede993d4c3dc2e15a1ee8e435d1662d8d5c7c9" => :mojave
    sha256 "fa9c98481bd8cda4a6ee990fc62388304c9ae34ac60c8d3d4ea02ba8b5c7dae5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    os = OS.mac? ? "macos" : "linux"
    system "make", "out/#{os}-amd64/crc"
    bin.install "out/#{os}-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    if Process.uid.zero?
      assert_match "crc should be ran as a normal user", status_output
    else
      assert_match "Unable to set ownership", status_output
    end
  end
end
