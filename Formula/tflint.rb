class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.15.5.tar.gz"
  sha256 "fff64b196a7872e536928da0e7da55a4ed3f15200d2b3c44d3064016eab7e4ac"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d1638d37c836a2a8aca89a4126991322be3c6901bcf69d5f482c167dbe87a7" => :catalina
    sha256 "74b7d14089aad6eb18732bf18cd8c1552d312433909d5ade6d9f9ec08e16b2b9" => :mojave
    sha256 "1bda004485ce0845c09cc56ae4b91eef7d06908d2afeebceccd51b63a27ad5db" => :high_sierra
    sha256 "442077dd5030612c45ec24865dd90428115c3a4f76c41dd7cb178bc227302d55" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
