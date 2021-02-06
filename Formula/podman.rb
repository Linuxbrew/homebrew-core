class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io"
  url "https://github.com/containers/podman/releases/download/v2.2.1/podman-remote-static.tar.gz"
  sha256 "fcaa81f63dee7bbb1e5dce60d3877eaec500a24ad02978c1263dd6e7c669c070"
  license "Apache-2.0"

  def install
    bin.install "podman-remote-static" => "podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
