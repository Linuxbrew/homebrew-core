class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"
  revision 1 unless OS.mac?

  bottle do
    sha256                               arm64_big_sur: "995792cf80b2355a0e7d232e01fdacbf69f90ec3c3e238107168cf833d116d91"
    sha256                               big_sur:       "30892c83aa5f7230362dc63137cc57594f23988ebe2dbf0dec2a3727ad2a5ae5"
    sha256                               catalina:      "d72eda905c674d931486371654242fcf72d88a9c18e1b318d6c735ff5addcb5e"
    sha256                               mojave:        "7c90660cbd7eb47df47d94a7831aaf86c8e7ebf52be952d7765092b21e6d3b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "702cebd398b557a7cecffe0d39f59e5c486759c237e65cea64bb051bf7a6bd05"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  depends_on "gcc" unless OS.mac? # C++17 is required

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/brew/issues/6070
    ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib" unless OS.mac?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
