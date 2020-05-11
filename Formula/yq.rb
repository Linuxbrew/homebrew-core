class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.3.0.tar.gz"
  sha256 "93998c2c5f19f39301929f3da99ac083fb82547ad9c00cd761c0a94967962801"

  bottle do
    cellar :any_skip_relocation
    sha256 "d581402395e5016b0f4eaa7e6ac00b97cd45b219af73cfcd99c90ea581db5768" => :catalina
    sha256 "610d4d7de00fff829e57a35d595d75f81e51cb060bc44b7b48e418021b733245" => :mojave
    sha256 "37c26ef0a9828f5eb7bdc83e8de9d28ded381f628e7681c07da7fc49402d816e" => :high_sierra
    sha256 "bf37bca5ba3297c05b1a8b486d456dfb10dfb2db2651f3c975d01aaff21917e6" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
