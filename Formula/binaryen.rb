class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_93.tar.gz"
  sha256 "a770a26dea4da4b33eee4a020f054196e9530cceeeff17b977e2bc6e4fd2dd7f"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "542a3a9f214a64b6ec9d752205b32a7272a4ef2fcb2d2acc42edb24007977b41" => :catalina
    sha256 "d254905d6b64bcd9ba048e918456493ee940c3a1c7ac986ee8efd0e2237e9b82" => :mojave
    sha256 "7e47f39425c623844ce4d69eadad6f8983121cdd8170848457199769c3ae62ee" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
