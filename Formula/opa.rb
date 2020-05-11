class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.19.2.tar.gz"
  sha256 "f8ccdf7ae2a9766654a8466b4287b5d55ad4b3f55673e45bd10340c93d967746"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81347c9b9729f35f645eb0c4e9b6c2989f429d1029f4f23273cce89e31fb7a0e" => :catalina
    sha256 "67a6fe1b8f239beba01b86f80eb4cce47f78d65b9018d923ca0f7136c877098c" => :mojave
    sha256 "f47afa26136544e73d9de191b2fc0dd29af52ed3587c4295afa090c25f8d6d76" => :high_sierra
    sha256 "a028f1942d199b6008f475e25ac335e4a99c74c15004fcc4a6be60305424eb5d" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
