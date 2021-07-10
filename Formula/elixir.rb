class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.2.tar.gz"
  sha256 "701006d1279225fc42f15c8d3f39906db127ddcc95373d34d8d160993356b15c"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9931199e37b5ed93b73b10cbbea910f735d537d935f7e0609645e828d5883a0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4911491569ca202ea71fb36a4bbb50bc89ddb936148660f0c8a484e4f0b84052"
    sha256 cellar: :any_skip_relocation, catalina:      "e362b53d078cbbb93b016f5e0efe53347e2c2b18c44419dc80070570c4ac11c7"
    sha256 cellar: :any_skip_relocation, mojave:        "00b036d03064ef97c3cdca45577a412e22304f19b357d1906098161ab7da9450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ad23cb38af4672b77ee757484fc7b25d20934f4b49d12984ba841016677271" # linuxbrew-core
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
