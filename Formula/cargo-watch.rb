class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.8.0.tar.gz"
  sha256 "9816b102e61c4257d6052ef4b196f67f40bab69143899f0178b5ccd9a29d384e"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb1111dc0d3cb395b88ce0213da3dae7019f908f6d89ae0f598126d1359c1bea"
    sha256 cellar: :any_skip_relocation, big_sur:       "311f7f929ca790a0c091471bfd34157906b6d7a4a78bd4786162cf9fe512205e"
    sha256 cellar: :any_skip_relocation, catalina:      "e81d05e4010d3ecdddd31e109871b849e1ebedf02241b8053b80b7ab343ba70a"
    sha256 cellar: :any_skip_relocation, mojave:        "fd9f1123d863da4ad81fc80ba0a22a5e7b02cb2e14f6c700621e9c7c9ca1bb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a47b79c19c717912e80541b0d1fac02974b37ae6232e12a51395fd34c81a84d5" # linuxbrew-core
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
