class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_100.tar.gz"
  sha256 "8a416b61ab9031240f8ba51a2a422c6ae99d4db1966a7bc7a6e515fa33e7a21c"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "44403c6f0ffc22a7f270fe936702d62981535e234f38f8d95544c9c663bacbbd"
    sha256 cellar: :any,                 big_sur:       "dc1687811e112b21a6fb4aac217bf12ecedba0ccfe806fdb537a19c48bfa9ec8"
    sha256 cellar: :any,                 catalina:      "abdee68b35c42a59d9a71f38f50e704fba8c9b475d7df8f34957c1b1c4221d3c"
    sha256 cellar: :any,                 mojave:        "bc4ca1066209a412279aaeafb2c2a5c6472fd5cc8dbcc88c8aa91da0eadee680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64afee1d88d6cf3b0779e5ebb45994d7f4e1f1d223536a8ea8e6706800975863"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  unless OS.mac?
    fails_with gcc: "5"
    fails_with gcc: "9"
    depends_on "gcc"
  end

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O.wast", "-o", "1.wast"
  end
end
