class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.3.tar.gz"
  sha256 "875f5a3faaee153c84d85ecd213fc833fa5601867310bd7b983065ececc2c2c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d42c28e3502043aa163cb786f02282f87942ec3ca71b00b1340cbc3ea113d3da"
    sha256 cellar: :any_skip_relocation, big_sur:       "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
    sha256 cellar: :any_skip_relocation, catalina:      "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
    sha256 cellar: :any_skip_relocation, mojave:        "81433cadebe1ac671fa196edf4533b66e66ab31610cca6a49935be058dd3b23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf84e2cbf77442e8b06269ac13c98d70589ad38a7111cbca8553b1561a89554"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
