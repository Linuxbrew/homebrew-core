class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.14.0",
      revision: "4b3ca59af505c4ab5d5b6960a194e1f6887018f8"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2dec0cec1ab85644fcc8f4a1395ec4e9503e490fc7e8ec55184e377e0d673b1" => :catalina
    sha256 "6640a549027d28aa390fe1cf954bf9ec9a541989ba23ca329aae16089ab107d1" => :mojave
    sha256 "3849686f701c41f81471375b2c188058da162129ae97f8ceca1577da2ab959fc" => :high_sierra
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
