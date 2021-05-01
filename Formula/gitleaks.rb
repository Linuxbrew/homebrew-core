class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.4.1.tar.gz"
  sha256 "144f30e83628f81f83181685e4d052f597c2a2ebd03bd15f50d02f2da851f92c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c56bac324eb28a94ab77922468dcc978c6f9014433ffdcd0c00d2748d045d2ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "765fd74ebabd6a0fd5d5864c1248355d98cd338e6a34d1684671c51cb30be3a2"
    sha256 cellar: :any_skip_relocation, catalina:      "65d2fe04969c1acd00571ee55d8ef23c672ab94384ac4ddc59d918b64d547510"
    sha256 cellar: :any_skip_relocation, mojave:        "47a35736bc72ffb71c65d933843ac4f65a480ab60c8c50ef4af629cb580ec402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b467c01ded88ab05804bfc68a2bec540dce4669c0994e83e009616bce02165"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    output = shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git 2>&1", 1)
    assert_match "level=info msg=\"cloning... https://github.com/gitleakstest/emptyrepo.git\"", output
    assert_match "level=error msg=\"remote repository is empty\"", output

    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
