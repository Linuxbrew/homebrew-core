class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.5.2",
      :revision => "68d381dde45b34f82a7247f20840829f1ee56fc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0f4c6f260007e5c8cb6f7d8842abc429891c5c75ee92cc8f254a965db9480fa" => :catalina
    sha256 "b0f4c6f260007e5c8cb6f7d8842abc429891c5c75ee92cc8f254a965db9480fa" => :mojave
    sha256 "b0f4c6f260007e5c8cb6f7d8842abc429891c5c75ee92cc8f254a965db9480fa" => :high_sierra
    sha256 "92b1f0ef6bfecf3ee5de3ef8a5ca54eb38e0a61711915baf8b9a319a570e6762" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
