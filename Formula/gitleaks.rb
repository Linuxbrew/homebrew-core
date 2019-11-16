# gitleaks: Build a bottle for Linux
class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.0.0.tar.gz"
  sha256 "8f1c78c15e779643112e5c12ddaa05f103fe24b81bd628b0e644335b65e26cbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcaf26aa8ab448bbda9fcaeb247d8a2d0cb3f8cbd330e9eaed5998f859b6443d" => :catalina
    sha256 "c8770283827f584775099d4f6d4372d0797dbbec19bb7f3be5966e8ee13c5157" => :mojave
    sha256 "796986382740df5919ff039a0e9eab15ff1d74958cdc3e33ae9b0f10a701dc5c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"github.com/zricethezav/gitleaks"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gitleaks"
      prefix.install_metafiles
    end
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
