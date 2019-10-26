# terragrunt: Build a bottle for Linuxbrew
class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.1",
    :revision => "97a66d728ef3b31034601030b3bb148856a2f7a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c403a6b8e793a1b0c3334768095093a0a4afcfba22ab3c8e453d7e18d2e03d35" => :catalina
    sha256 "3525aacf94ae5fca72da6f58e684fe5466b7119c11ad5fa6648945a878c698b1" => :mojave
    sha256 "789789835b3bb964cd355d7860756fcc260c8471ef5588cd50ec0a2ae1749d67" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
