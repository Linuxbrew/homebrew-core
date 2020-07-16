class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.12.1",
      :revision => "ccd40dcee12171c96fd96f9a959d549971c920c1"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6d044e89599bc50bb6c7bb527f653ad2b60ffc97918390aaef0edc8cc4168cb" => :catalina
    sha256 "4ec58a62b89267482ff1d2459595ced035124a8e8d82df0fe624a39ab1c7e4ee" => :mojave
    sha256 "644c590fdaaacf9fd645e20030d92b2c32991ed2417158101e350d2d3f3f2770" => :high_sierra
    sha256 "dd6bd637c7a54fb9dfce596b12689310116862962862c14f3b44224a8840da8a" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
      (bash_completion/"skaffold").write output

      output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
