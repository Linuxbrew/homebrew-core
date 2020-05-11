class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.16",
    :revision => "37832d50c576d4b4e120e17baf13bdec516110b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2e428af9285cd6f120c26b99f875f7cd653abfc318080533cd440bae6c71148" => :catalina
    sha256 "65648c0d1c7f6111db08bf77c215f9e47449a172e7a42a7dbd3ebe3362a59323" => :mojave
    sha256 "6f7d0ae6194405e653944438cf40eaf80854feeccacc269020b84bb078a18162" => :high_sierra
    sha256 "5db11c8697c3e019b366ab344a063b05484047dc63c4c85af7d23603313c5107" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
