class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-07-13.tar.gz"
  sha256 "e4176167bba26eeb7bc7bbf5be45d261e05e231331135dfbc6f12f927ac6eb60"

  bottle do
    cellar :any_skip_relocation
    sha256 "83ff4f7272c5e54f685193dc9dd48547fc230854194c235e349e12a6d8b057ed" => :catalina
    sha256 "3ff631a2a0b6507459157bb2e4fc9b896053c6d0df9013b23057bb00c7b30af2" => :mojave
    sha256 "6a9c94d143e9868d787fa333650684b39293e399f56f8b2c72932fcce41365ce" => :high_sierra
    sha256 "75be1179cfd9b26c7bd2cb367e9c01233c565bc7c3263e43a6e6a788d280ca04" => :x86_64_linux
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
