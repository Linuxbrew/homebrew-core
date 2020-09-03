class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.1.1.tar.gz"
  sha256 "e6c1da674b38a082a7c49c202380148b934eb60229d336a5049efc2ac859385a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4e9ba6eb9d38902153159d95b4f70fb764a3c5e96cb97d3e096040087c7da2c" => :catalina
    sha256 "ebdc61c6027b0eb94da4b1e1d509b192b098a4c2419692047f7f455042200773" => :mojave
    sha256 "126cbb63de4d2ece3cd93804525aad9f6db8f8a5bb41688d43c2c41b6f04a8b8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
