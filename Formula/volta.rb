class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "a8186ceb9c0c015730d81054894a5a3690403d7a",
    :tag      => "v0.8.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "86f43039b995b4337a89a97033ba29bae48dd53d5d39ebea36f4076e767acbfc" => :catalina
    sha256 "a4d0863739845e2a8e7956e35c10d7fdd3e6a26c8abbc34251b4bad69f6edc02" => :mojave
    sha256 "f7963681782fee49a6b77e3aca7fa70b0a346aa134410e3ce68256cb7935c68f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
