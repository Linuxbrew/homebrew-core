class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.14",
      revision: "6e753b5aa63ee34d49fade16940d92714702ec55"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4acdfc57577236a0753dcd5b05c3feb28ba15a61c0f19a5e4f77bd69f5004a41"
    sha256 cellar: :any_skip_relocation, big_sur:       "c777c73421f25a83c2eaa2a5fbe8ab6cfde94c538128267e08b79b3f1fcc6ec8"
    sha256 cellar: :any_skip_relocation, catalina:      "64a1d28a9a243b0b7e29a671e995a453309467c581dc9a7d0e8631447bc775c5"
    sha256 cellar: :any_skip_relocation, mojave:        "b057cbe93925f65c69283b677702cedf6ba73e1cda30847da0d27d5de3ac2142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eadef26169ff9c0a13ef947db1342f2a8b760254d6921d1ab7de64ebaed23edf" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
