class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.5.tar.gz"
  sha256 "b4d697e0e75773041069ad2874e08a8ebe3f7341b47b7bc9ff825115dce910d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b677282c113016d5a2292870ff316daa99dcee19adbbbfd466340f88a66e0794" => :catalina
    sha256 "2e781da01fa6295a8cb8ad4240bccdc0148af0dfd712475d26e373a19493c758" => :mojave
    sha256 "89570707a2c183c68c78b146e4d77d1c58ca323be2455b3a31f5e60624b06138" => :high_sierra
    sha256 "96d09fad3dad4d48a1ab1d86ce5b7c85387382842e7ab7f8c906ace296c70a65" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  depends_on "pkg-config" => :build unless OS.mac?

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
