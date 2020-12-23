class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.12.1.tar.gz"
  sha256 "93797ef144f863120d305691913a21a3c42881c6cbc5a07bb2fe8336456e9aa8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a197a01d2a4ccc244b3042a46dd1c498ee02480162fc9deba37bf74ac533192d" => :big_sur
    sha256 "a7f9676fbd4db882933f8f55bf649808b820057b9fb7eca2017c28389cee1c30" => :catalina
    sha256 "6e99065ad1c05a84707f42871a2852ec5b0d94cf8b98fb6165baa461d19f0682" => :mojave
    sha256 "602eea271860c2baefc912d19985395ec70484ea9239304e9c76d7f394d99eb5" => :high_sierra
    sha256 "64b3ffb3a3ddd716ab0091a14a74549b8b10162c45b2bd3444319ff98219929a" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
