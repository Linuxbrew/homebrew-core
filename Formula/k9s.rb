class K9s < Formula
  desc "Kubernetes CLI to manage your clusters in style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      :tag      => "v0.21.2",
      :revision => "977791627860a0febb3c217a5322702da109ecbb"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    system "k9s", "version"
  end
end
