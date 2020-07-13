class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.21.1.tar.gz"
  sha256 "87813ab618fd465c6becfd4bb32c2461257d80e5ddd6eb13de0a27a195a4cccf"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75c60b2042d8c6336450dcd439e743ef0602cf270e5db396f21bb1674f6d8138" => :catalina
    sha256 "aab236e6b10b5a6cd1099cccb670c9320908bacaeb3a5500903d06fc5b9b6b1a" => :mojave
    sha256 "53d3b23e6d966b4d0f4e8d742fadcbdbf6705d74e6d891567e9b00c9d1370aaf" => :high_sierra
    sha256 "d2c78a7ba8a068edfd45ea1a84b70faa1ba7cd847eda632e64a193d3f60c3c5f" => :x86_64_linux
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
