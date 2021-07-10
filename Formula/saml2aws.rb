class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.31.0",
  revision: "a2c35324b19242378a79bd8a8453d12eb9abdbec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7eeccd858430c6af458ed61299df87bee2833e5f90c1b2c8d4b22f9e37dffc09"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d1d99a82f8237a0a71213007a3af5e1c32e9baad5e0128301bdae2a260e97b2"
    sha256 cellar: :any_skip_relocation, catalina:      "7323761199de5a2c415e8876c801ecee5beab58530403864c2df2df1e8898598"
    sha256 cellar: :any_skip_relocation, mojave:        "c4a3ecc94ca7f0001291f7c3d26d15db0508188a7c3e088f091db2b8e20506e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a79b1f52fd67bc9ad9d1485fcd961ea08a0beeb3639ea304180c7693c9e3d3" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: failed to validate account: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
