class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.1",
      :revision => "65f946ae5c798577b282e8b3fd12974b41f43bf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "5235b427693ddb286ff0855d25b26a52b7f110c4f76702a64e08b06fa7579435" => :catalina
    sha256 "102510c41ff2e38f4b9f6de63221a8b5833e0e947bef676e7ed68ffa4c8bad9e" => :mojave
    sha256 "07f83319cde446ea486a6befb5d4d69422893f6ca6c10618a3670b12b86b4fa7" => :high_sierra
    sha256 "58ca34a76537a47df4ed2d8573ef090f1565748999bd55e24b932ffc3a3540fc" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
