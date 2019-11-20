# helmfile: Build a bottle for Linux
class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.92.3.tar.gz"
  sha256 "93263afdd0dda007106dae948418a2ff95d2c4998afe838eeefe94fb62d30abd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85ffdf4d38ef6e8fb596f5ce3cbe10c3baa330854cb186d665a4f01367215a3" => :catalina
    sha256 "05a7faca9988493cf191c8f7e42bbc1c9731fead341bae00fcf05365cfa255f1" => :mojave
    sha256 "fd1383f23964ff3195e4aed07ddae0343d64e62ca0e948e3a68ada75dd8001ea" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X main.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
