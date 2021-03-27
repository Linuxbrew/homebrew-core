class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.7.0.tar.gz"
  sha256 "909496eaed98f6ff4fadc216ad904ef2d2a82ff229e6af6cc0cb1625e2df5d83"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfae75e244e5c86b57e9b37f5a6b8784ee0d6dbad104591e2948511993e7b94e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4071aa13bafc29694e81fc4a9ad1c3536fd4e35e1d31d8f8f1c51fc785c75c2c"
    sha256 cellar: :any_skip_relocation, catalina:      "da4b750edafa4fbaf077d610eb1dcee9d7b4d6bafea46154eb6ec30803861040"
    sha256 cellar: :any_skip_relocation, mojave:        "4afa9c1aa66738a4a5548ff1d0a2f974b6ca40b1d15df9a03ebf7742f0677e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c955455ffb0e2cc3cea05ee455984942e04b9e26c909a9297617f8593f312f20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sops", "go.mozilla.org/sops/v3/cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
