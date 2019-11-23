# cargo-c: Build a bottle for Linux
class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.3.1.tar.gz"
  sha256 "a8e662539218728372f6b8fbbbd72ff2092ecb71fb4ffef7e6a3969a0734e58f"

  bottle do
    cellar :any_skip_relocation
    sha256 "60ab4670d7d8954c1ebd134ed756f0e0746985f5dddff5fed384692695f337dc" => :catalina
    sha256 "3de8001d223896ab8f6cb77a7ad0b831ae89cf110358b3d035e7ee931899369c" => :mojave
    sha256 "03c13c18e514d066e9d959500325130d4d66f4d5c5997e7fed44117df4b3028b" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end
