class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
    :tag      => "v0.10.0",
    :revision => "7f5f485a411aa08752fd6ed4847c8013e95f92d1"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a54f8f418c6ecdfe47395565087a4cd178e6e1a88e211c9af09ac65088e24125" => :catalina
    sha256 "e6dea5997e1f3d171eb3ab3dfe3ece611ac47a89b94e46aa679e1ed407a3d475" => :mojave
    sha256 "c540615f2c51aa62fd70c6b0ca31686c2b24216c5873c0e93520ef349296f8db" => :high_sierra
    sha256 "92d38c71cb23f6c52829b3059da5d72ac148b6968864c4e5b5848676c04ca8fb" => :x86_64_linux
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
