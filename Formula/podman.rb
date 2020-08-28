class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.0.5.tar.gz"
  sha256 "cd7618429f02db8e7dbca29c6f8a7623a91a01804ef768dc5ec8c7660679b0c5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "647147b88c45819b1cf5ce05d398ed0b189dd62ce7f11d21c5ac9e6eec8b2b1e" => :catalina
    sha256 "bbfe435b888c28d2c1ca47cdc625b1179c25275bfcdf252cb4175791f3de59f5" => :mojave
    sha256 "332ccb7dfb25d245b6f86c68cab73b33b97631d9d738b0b2310d6e1351bfd880" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    inreplace "docs/remote-docs.sh", "sed -i", "sed -i \"\""
    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get \"http://d/v1.0.0/libpod../../../_ping\"", shell_output("#{bin}/podman 2>&1", 125)
  end
end
