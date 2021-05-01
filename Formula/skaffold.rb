class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.23.0",
      revision: "e8f3c652112c338e75e03497bc8ab09b9081142d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d7bf507e0ca72c063fa781e0f4ce9c334f1fb2e62462cf181565cb3935005bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "11ce1fecf88517f6f8d0cc47118c2d7b64c14ca7bbac07a29f5e793abe5bac76"
    sha256 cellar: :any_skip_relocation, catalina:      "85a2df1a0e854e5ee35674bb4016b74184dee3d6c71d83dd5584e85df94abbf2"
    sha256 cellar: :any_skip_relocation, mojave:        "ef99858f698181895e3dc9e3cad5edcba41782c8c47a0635ded4cc61d5022df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9531282ee6bea61a0c18ad623f11d65d2c50c675050382d3e9314c98f47d07"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"dockerfiles":["Dockerfile"]}', output
  end
end
