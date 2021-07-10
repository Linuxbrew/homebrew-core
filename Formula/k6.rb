class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.33.0.tar.gz"
  sha256 "c532013f302996e409ac4e4c73b053320f7581b101351fd3053ebcf2fc2a3e07"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3eaffa822607e25fecd4bb9da3df729514c8caeb0c3fb9fa7422fe34ea2ee9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9630025b40877144cdb0048f13ab64f429bae7ff0140e51fa4944db6493839a5"
    sha256 cellar: :any_skip_relocation, catalina:      "09a62bfb818944b4bf8c6683ef8c4b5e1b564b65c6fbd6c47751b690ac8f3831"
    sha256 cellar: :any_skip_relocation, mojave:        "8431419ffeaf40640ba0555b747e48a71fb65576d2121a4bbf25ab73c70e2b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2759d43340a9dd20a54ffcd150b312ec848714ca4eb058dde4d36fce4643e7" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
