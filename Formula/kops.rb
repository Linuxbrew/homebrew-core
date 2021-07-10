class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.21.0.tar.gz"
  sha256 "b6246cc58e5ad2c9566238bbe99ba8ba1e9593b016336ba5dd6320f66040ac40"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7741e7c13fce8e0e46defc2ede4d65d19a668ca42afa298b90247d9649d081f"
    sha256 cellar: :any_skip_relocation, big_sur:       "23dec5163db7d299b12ab1ee3ec993ffa7bca1065ed4579d79e787332def6190"
    sha256 cellar: :any_skip_relocation, catalina:      "53b6da54ecb3c4ec63296bed6f29359de2fcc60c193312a3b12c07dd046fbfab"
    sha256 cellar: :any_skip_relocation, mojave:        "85a9c1af389f0bf9255dba02e2be8a35bbd8bab371f693bbae3bd1bf1b574f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82244c03a8b58997657bbeb273cb74c7f6cf7711682a9fa6b1e3d4a10be6ae0c" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
