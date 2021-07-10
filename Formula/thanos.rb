class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.21.1.tar.gz"
  sha256 "db8e6fc27f6dbaae59efe73c08ddc2bc79cc10c331aafd42ee93d03a7a6459d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc0d0653d316182d3337117ed6d139ca0610c6ae3cfb984ccb9bfff53b86bb32"
    sha256 cellar: :any_skip_relocation, big_sur:       "56961cbfcb49226f7ecee46c1225a013a34dcd76167952a20e90b853bebc2e74"
    sha256 cellar: :any_skip_relocation, catalina:      "69166b1da6ee07d6257fb3334f992ef168e83012dea18a011ab786eccf670277"
    sha256 cellar: :any_skip_relocation, mojave:        "9fa302ae777114c48f92e3347b09e26157098465b860a26496763e0d9218272f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b5137f73960dba1115d2d767fbd092536b924ae638e3536308f8d1eb9d8cc7" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
