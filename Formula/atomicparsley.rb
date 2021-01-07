class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20201231.092811.cbecfb1.tar.gz"
  version "20201231.092811.cbecfb1"
  sha256 "b38f3483ed07aa556e3faf070630a73035a69e57a182ed4394b1974da7c59f88"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10ed6bfad101b5e57fd8d44e9485033308b56d09b4cc08bcd02d9b0eb45c7595" => :big_sur
    sha256 "5b27fb350ad43a09587dd8fb606b70b5c839c6b9a4079e054def9ffa58c3f69c" => :arm64_big_sur
    sha256 "164a92e2a72ac3f1e3a47edaad51114d83582019722d8688299684381299f5eb" => :catalina
    sha256 "04cdcb145d63be082b604db3b79284987c6fdc042b7b5451fd28b21789c015b4" => :mojave
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    fails_with gcc: "6"
    depends_on "gcc@7" => :build
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
