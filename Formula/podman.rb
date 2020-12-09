class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.2.0.tar.gz"
  sha256 "ec5473e51fa28f29af323473fc484f742dc7df23d06d8ba9f217f13382893a71"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "927cc691a21d6fe634520ebc256be8ff9d1fcf83061c295e2761fb68e7df987d" => :big_sur
    sha256 "d2a977729d400fce60e1d794fee370a8a2f68af255c81e45b44808de33d4a9bb" => :catalina
    sha256 "0ff5d26fee613bf26aabc941023b02ad6785873ad114828bddd2885865bcc828" => :mojave
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
