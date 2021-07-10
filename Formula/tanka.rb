class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.17.1",
      revision: "3bc0931b899432ab1e9edcff9c4e81a1bd3250b7"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b86b36181477f257de520c2ca5821956ceee71935f103f59990906a97c120db"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8f898d15e1ccb7b5dd8c3d3130d18e6e71e7acf80e9a5d167c812422bae00a2"
    sha256 cellar: :any_skip_relocation, catalina:      "9880ec02a1ca51c6e3bc1213187f3b2ae80bccbcaae0493be3c89424958f7b93"
    sha256 cellar: :any_skip_relocation, mojave:        "49f9924c88518aadd7c6ec253fb35aa4f0e05ec506db70fa1b3ce656b47713f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163e296cd3b4a3b121641cdd3035fb11fba7a4b476ab8abe700e30fe204808e8" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "make", "static"
    bin.install "tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
