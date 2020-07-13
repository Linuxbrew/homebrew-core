class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      :tag      => "v0.21.2",
      :revision => "977791627860a0febb3c217a5322702da109ecbb"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "713ce4d49670c5ee47425bed9b9437d3d5fa47ad84691a38e9cdc5f73364aa7b" => :catalina
    sha256 "71dc6a54bf42b169d4f1001a30fd07008ccd82907101b906af9c9c74eb8b64c1" => :mojave
    sha256 "d6f54aab8f27a08e4d640e7180e42aa070816b15e82a51e13e6e4d6942fdeab2" => :high_sierra
    sha256 "6f7f51efaeecf24a9e7b96b85705bee2ffdf413111dce6a482ccbe35b02ff1c3" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    # k9s consumes the Kubernetes configuration which per default is located at ~/.kube/config
    # Its location can also be set with the KUBECONFIG environment variable
    # Setting it to a non-existing location makes sure the test always fails as expected
    ENV["KUBECONFIG"] = "testpath"
    assert_equal "\e[31mBoom!! \e[0m\e[37mInvalid kubeconfig context detected.\e[0m",
                  shell_output("#{bin}/k9s").split("\n").pop
  end
end
