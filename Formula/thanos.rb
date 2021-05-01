class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.20.1.tar.gz"
  sha256 "e3821568e5d36ba1d0206eded8e9ddaf9950dda2032c1e122e4fba340c9efa7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dccc88f3eb434ed662690870dc5765a3fe23660473601c9e1d0f503121f398e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "262fa21cdfc341b92a2769c830ca746bf90ad59b8e4705e6d61ed19a80b932ac"
    sha256 cellar: :any_skip_relocation, catalina:      "d983ad448244b9f03553a4f6f53d3b46dde61a94ea5d2b8781bfd783433ec68b"
    sha256 cellar: :any_skip_relocation, mojave:        "f6b2e694992ea871af7b42e9ea9d62d2f9030f24223c8dfba1ffeea4dfc5ab73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4039ac0cdc39fd4a79f79368e2d7c3e9a55e1963e4ff25f2e24562c6ac59668"
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
