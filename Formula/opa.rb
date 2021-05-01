class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.28.0.tar.gz"
  sha256 "7d519fcb4d50fdaaaa77405987281484eebcb1ab4f433408df1d0a4a73896281"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1ac93edf390fa6ae61f71060ccd2bc5fee1743b8826919d4a9a27dce3884e9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef48d8bffd455072906d6367509bebba2909f652fdd0ef4ee44fc2b980e4c793"
    sha256 cellar: :any_skip_relocation, catalina:      "f0396952b79b701f2edec59f9526c9d379f1a4c4d5b90a94354e83f5e00408b5"
    sha256 cellar: :any_skip_relocation, mojave:        "a012eb7c26bfa3aef3c5a26d37cb930afbfb224508916166708a7cb0d9a37915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197a276c2f771bede3fae52f025a022f64970aaf8981785aec0eab33bfebb5dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
