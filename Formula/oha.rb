class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.3.0.tar.gz"
  sha256 "c40370639b2e2fba2d1d702185094a6e0a05d6524ab16cbadf03a9227240572e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a95a7d0c74e587c2a22e5f3883d4c4f221457f4b1d3b949eea6c8f69307a237" => :catalina
    sha256 "64d4b2fcc06b45d01cca70fb2e21f0365420577ea298e12014b6a61f4c2765f2" => :mojave
    sha256 "87f11b14a7664a7fce576e146bb65d950dfe1d30530cd84d939beb9ce6182530" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
