class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-07-05",
       revision: "e5c1c8cf2fcfae3e15c8bcf5256e84cad3bd3436"
  version "2021-07-05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9196e5d989d43b3eb6bf112aca76c03391d1fbf4c1904b045e943a6a7483109b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c786d49a730d61a2745cebf8406cf8bcbe8789dece57897bf97698cfce60e1c1"
    sha256 cellar: :any_skip_relocation, catalina:      "d3b1e3e6b557d2fafdebc96479817619da3a00968a5bddaef6852dcc33c35bd2"
    sha256 cellar: :any_skip_relocation, mojave:        "21c651ce6be7c75433bd13f9f61a0dea40b714998d1680e89bc9e30adb28a3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae032bf58ad1a5e3666d78252bf772e03ebdf042c5f770453141b4442d574ce0" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
