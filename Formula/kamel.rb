class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    :tag      => "1.0.0-RC2",
    :revision => "24ddce5afb41c70a0bf30e06f74c6f380f5fd851"
  head "https://github.com/apache/camel-k.git"

  bottle :unneeded

  depends_on "go"
  depends_on "openjdk"

  def install
    # Build from source & Install
    system "make"
    bin.install "kamel"

    # Install bash completion
    output = Utils.popen_read("#{bin}/kamel completion bash")
    (bash_completion/"kamel").write output

    prefix.install_metafiles

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kamel completion zsh")
    (zsh_completion/"_kamel").write output
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    version_output = shell_output("#{bin}/kamel version 2>&1")
    assert_match "Camel K Client 1.0.0-RC2", version_output
  end
end
