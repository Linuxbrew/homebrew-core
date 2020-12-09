class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.0.2.tar.gz"
  sha256 "b57cb5d1d97c42f3d02aff1c3f174b91f0839f8d4d6b47a1f43f3f4fb7054065"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f1979982c63212f724f97ae22cb59c88040efed7cfff4ebe76a78f3252dd61" => :big_sur
    sha256 "6d7ad52564bd62e9b69b7a12385fc58890a8a060d44cbb200ea5d2d719585f23" => :catalina
    sha256 "f9d255b5943d4ed8435344766cc40558b830e9bd48988bdff71f74c109f0f640" => :mojave
    sha256 "b9edc2324da89a559adc924e6953ed11e51207fe1e62e21e3b5b167983bc4c82" => :x86_64_linux
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
