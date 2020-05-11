class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.9.0.tar.gz"
  sha256 "8fb30323699e4e835c3e52f9aeabf7424017b617e55b4c0fc0c33b723227a079"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b30c8486eb59fe7d66557e868038534e3163bce4df44b34372f4680c6714ca7" => :catalina
    sha256 "fac30c64974b7f2014e8f8a6afb7ef8e4584d9eab0706d9f0e9bfd6e519f929d" => :mojave
    sha256 "59150755c99c36a478a6b7d2f905de6e6d46d11c6e3b4f2a2f9c02147ab9cb1d" => :high_sierra
    sha256 "0c351b88c78d8b611d58ae224dac36a2b27b78aa3c5953a70d937c31c71106d7" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.popen_read("SHELL=bash #{bin}/tkn completion bash")
    (bash_completion/"tkn").write output
    output = Utils.popen_read("SHELL=zsh #{bin}/tkn completion zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, :err => [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
