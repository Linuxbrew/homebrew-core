class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.3.tar.gz"
  sha256 "b599f1f8278c9c6bb9d6c8024659dddd36875592445a23de5a047ef92015b4b2"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca16d0feef0d4a43bb6e31b92623d7f7ef840dc625e73e37bab6ec3f6a5d5319"
    sha256 cellar: :any_skip_relocation, big_sur:       "414396db3ba33db00ee7f420c19748790004053daec9a3f5a9bf6574b26db729"
    sha256 cellar: :any_skip_relocation, catalina:      "c1ed49255a527ddeaa69ee66a02b5a126caf73abf54c190b2a4c3aa0d3fcae02"
    sha256 cellar: :any_skip_relocation, mojave:        "f07b9c5a1dee3d80e3d79bfa7ecb4efda8b01b023c4cfc9aa32d14b21545e2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c18d39092ddfa93f8ec235ce98344a12538c0b380c0c1cb3632f09d5d1be99e"
  end

  depends_on "go" => :build

  resource "test_resource" do
    url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
    sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
  end

  def install
    ldflags = "-X github.com/cycloidio/inframap/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/inframap version")
    testpath.install resource("test_resource")
    output = shell_output("#{bin}/inframap generate --tfstate #{testpath}/azure.tfstate")
    assert_match "strict digraph G {", output
    assert_match "\"azurerm_virtual_network.myterraformnetwork\"->\"azurerm_virtual_network.myterraformnetwork2\";",
      output
  end
end
