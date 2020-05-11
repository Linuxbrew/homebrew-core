class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.10.3.tar.gz"
  sha256 "f3035fc5fdade35c3592a5fa7c8ee1aadb736f565c46b74b68ed7828b3ee1897"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d02f86bae935461933e8dbde1052e954351d6adb39575df31b974ba97c5cb98c" => :catalina
    sha256 "267c46f18891050670a9c0872f155a646394ae311bf87491681540004dbba0ea" => :mojave
    sha256 "0d3ef8c94f9def9cb7dba9236ca215a0a6b0da34974393b771015c83bb81aed0" => :high_sierra
    sha256 "5c8695ed8c01089a4cde499964b68b17065e0a27b30802c4c1465b2da956ef8c" => :x86_64_linux
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
