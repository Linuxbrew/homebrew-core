class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.12.0.tar.gz"
  sha256 "7dd982b201317c58db71a9d2675ed61ad0f545aa6b7ed0408e2f729f4cac1a70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20bec97d2769cbaffcd754981e27f9551e966af9d373bfe7e8b0acbe544b4312"
    sha256 cellar: :any_skip_relocation, big_sur:       "3839c33cccff8401af9b20a95a368c8b7f098e72fb7360d859584f608e4b0ee4"
    sha256 cellar: :any_skip_relocation, catalina:      "33a1e7d096506deca112879aebea08a85689615e386a5b76ac10599e37ec75b7"
    sha256 cellar: :any_skip_relocation, mojave:        "50b07a5e1c2bf069d01af5d5910eda7877cf734233f000eb47914e9e878b2c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9ff4af92fc228527692d9a9180c5aff494e9cde7a5e7d1756e86e1a44daa462"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/#{OS.mac? ? "darwin" : "linux"}-#{cpu}/terraform-docs"
    prefix.install_metafiles
  end

  test do
    (testpath/"main.tf").write <<~EOS
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    EOS
    system "#{bin}/terraform-docs", "json", testpath
  end
end
