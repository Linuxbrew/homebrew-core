class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://solidity.readthedocs.io"
  url "https://github.com/ethereum/solidity/releases/download/v0.7.1/solidity_0.7.1.tar.gz"
  sha256 "c69205d902ac8dd66f5aeaa78a08e5411cdb26a0b9479fcf44f394b7008b484c"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c08040ddaab8989960f89de602ebe5b7b890b67ae081aa16f7d304f2273d52" => :catalina
    sha256 "f6d741893302638e028a59ccaaaccabc02e3b1f42655df5484a9d0063f4aaa7e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.7.0;
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
