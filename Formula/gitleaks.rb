class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.2.0.tar.gz"
  sha256 "7f2d96baba62325e208d11ff34f4bcf349be702f76dbf23faabb6e880e7f9665"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb6ab29d2d9beebc5fc37326d389d6078052b4f490960a50e2f3e602a881511a" => :big_sur
    sha256 "038438f9856f5c9e24d5cf22ce5530344d83497bf77436bdb1e8127bdeef138e" => :catalina
    sha256 "4b518371d187541f5fd08e9e9a7749c6e3058b42e1b9f6cd30701741ef5ea531" => :mojave
    sha256 "f7611a12cda9e3fee060612b7818bfe1bf07ce757dadb1f26770607c3e0d5c44" => :high_sierra
    sha256 "8a5ad2abdaeb1927861f13426524b40cd1a6db4cfdda31487bdf3a3857f7ead8" => :x86_64_linux
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
