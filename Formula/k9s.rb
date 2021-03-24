class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.4",
      revision: "5ea54e3881563fff7d223427123312e3e916ef6e"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73347f0a43037c5f34e8d86f8faacdbf2cd5ffc7085b4366d996373e9fb9b279"
    sha256 cellar: :any_skip_relocation, big_sur:       "df9237f90ab309788693ad4fb24699d73a458286af3d598eb04ab5be1ce3a2b0"
    sha256 cellar: :any_skip_relocation, catalina:      "d82da6e92b68bd59097dbef82da212cd92975a890ede20d98fa24f79e3dc8e0a"
    sha256 cellar: :any_skip_relocation, mojave:        "6dac5a4f1308fb5d83d70230bbd60929d4117d10bdb6b2fada274dd87d5c1b61"
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
