# gitleaks: Build a bottle for Linux
class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.2.0.tar.gz"
  sha256 "c4323390f4bf32177613aac4470cc58c54b48ed1a70209f28011f86f2997eab2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1149bb0efb00de9960f036a8cb44df9a70d43f6171e3a1bdcec40054500e2dcb" => :catalina
    sha256 "b325c01b93d5eb5270e732fb5c1812d3883f4f0e6acbd06537183348a78b8b70" => :mojave
    sha256 "f063a806f1b52d099691324072df85ed664950327f21b2a156396c9fedc1df0b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/zricethezav/gitleaks/version.Version=#{version}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"gitleaks"
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
