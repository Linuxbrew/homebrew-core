class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript/"
  url "https://github.com/sagiegurari/duckscript/archive/0.6.1.tar.gz"
  sha256 "0fcc0a3d24c8ba52516d748e270079457857580dd631a59dacbf4693fd0b22ad"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a9913515b46fa5450545e6ee310dbf8eb1bc9eb0192806f3035df54da288733" => :catalina
    sha256 "06d8c3e2e6bd97e6e37f08a268124e45363877964eb77af29d4ce392bbdce9a5" => :mojave
    sha256 "e6884ffb81b869777754e7737e2db7bbfa033a6c8c5c35afec6a739611651a1e" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}    
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
