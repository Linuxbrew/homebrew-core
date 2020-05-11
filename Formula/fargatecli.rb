class Fargatecli < Formula
  desc "CLI for AWS Fargate"
  homepage "https://github.com/awslabs/fargatecli"
  url "https://github.com/awslabs/fargatecli/archive/v0.3.1.tar.gz"
  sha256 "fd8627e6ab85d70f6b2633d8b35cfb1daad232ed0a29c72df57b9869810ab221"

  bottle do
    cellar :any_skip_relocation
    sha256 "3964c9be2a8489092918ea558c73585ee946e942540b2b3a90e184b80006b232" => :catalina
    sha256 "7bdf49489c1f9e4ae108e79204c68a3f77145befe1e4584e5f7cf3629ff4f1ec" => :mojave
    sha256 "f81fed7339f3291da266bd8e2410b1ba336d5580afa779d8018a6312354ec30b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fargatecli task list", 1)
    assert_match "Your AWS credentials could not be found", output
  end
end
