class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.13.tar.gz"
  sha256 "19f06f3cac38f680ceeac43314152d478f55ee0894a5b3ee6200bc27be98b5c8"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99596f8cda2cea8990f45a423ab51025a8525a4419f0757a58c0fef065fe394d" => :catalina
    sha256 "3f95f3c19c84d8e4b05d6700b5ca439e4f815b005081e43954d06c6d4bde87fb" => :mojave
    sha256 "095b693e6b14d7605d1b7dc96f40c6f14efd371e16a4fc102f29fc353353ec6b" => :high_sierra
    sha256 "a4e0a0cc8b3b84ec7b86439b8430dffb29ceb155d122d2ee000a5bce371cf0ae" => :x86_64_linux
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
