class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.6/solidity_0.8.6.tar.gz"
  sha256 "523c83417feb5b6c4b5531ce903ed60251ec9893ed665522a20ba027906038f5"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "036aba68d251572bdb3e86521e7e455e7cf36fa72c28bfb48ac57c8a3f94a7a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e6de6d7c6f489998c8c404eb6fdd3ee8587462ac40d227fb9aeaa8e34f14db0"
    sha256 cellar: :any_skip_relocation, catalina:      "9af8382f23feca4a81d6b4cec6cc3c615f04cc1fe8e044637bc54c33c4985836"
    sha256 cellar: :any_skip_relocation, mojave:        "e2b7089ba3173662899a0af592f783c7a16025c0dc03f56cfb203f2edcd9ac13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9026c0788e2e97582c28ea4fad2f6a3b22597db1c440e364a368e781a5c86cb" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS
    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end
