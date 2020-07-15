class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.16.tar.gz"
  sha256 "e8c9b091d9b886d474d51894230d250294def995c171774f6d6f6d01844ec099"
  license "LGPL-3.0"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fd7d994e7dc5c93feab9c21761878e0900669523b2a1ee24876cf12ce9c0c08" => :catalina
    sha256 "d61d49c110a82eae8b153cb9dc3577de605ed016a4a2dc7b26bd490bcc0c4461" => :mojave
    sha256 "2a26fa4bbb7a0244256d65f68ae0ff2ff787a73bd068d18493bcac94888bd492" => :high_sierra
    sha256 "fda5cc44a7ab30fbb0fe509dad346213e514628dc1b807cdd82bec37e447df17" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV.O0 unless OS.mac? # See https://github.com/golang/go/issues/26487
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
