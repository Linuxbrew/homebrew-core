class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.9.tar.gz"
  sha256 "d88bad2ada3432b15d2a871a5071f2bd7554beec5ecc4807c91599533de76cb4"
  license "MIT"

  bottle do
    sha256 "9dc00da6f8f3dc182d5308e6d369c828c7dd805ca124eb6b3a887ba7611af506" => :catalina
    sha256 "400fb6dad38d59989a79a47f7b8e10bb5f7ae82f63d865a55c23dde147e9cbc3" => :mojave
    sha256 "c0af52f84d2adcb56b3fc87987be77e38c2c6547cb4213137079dbf5383697d5" => :high_sierra
    sha256 "0ffe2f6a9050a513303bd4a39440a11b87b24f99ecce0bd65052c319f6ee09fd" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
