class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.4.0.tar.gz"
  sha256 "2e2eadd5cc5d7f39160de208fd4b98d78adc29365960db3c57c2df814efe6c1b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "86085a11dbf43d1edafd9e9fd7e47443ec11ab692b9b48a80c5ffc58a2f1b39a" => :catalina
    sha256 "a15bcbbc6085b0420bb9bc863acfffbd4a8fd05956dc66dd163caa8ddf731fc3" => :mojave
    sha256 "ef75c99c9d174815f7fb244f8b63866e0b27e22d5c35c9e37190da3293c7678b" => :high_sierra
    sha256 "206bd004980a01c0b63a85d9a7ff2cf6b13e5275bbf375cb1e6a8f6133be75b6" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"devdash", "-h"
  end
end
