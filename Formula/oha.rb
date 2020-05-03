class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.2.5.tar.gz"
  sha256 "a6e26a616f12eeffc478a74d1ada5cd39ac27839e05c11150a6e8a23a664c3de"

  bottle do
    cellar :any_skip_relocation
    sha256 "e067d051d52234fff0efb454bcca1b0b17f3ebf560158a51f136f3b3fa73d539" => :catalina
    sha256 "a4179722196bfc94042311342b5576a3226c1185ecc7be58a1a7e409ee0aa12f" => :mojave
    sha256 "706c1475a39d4486804d727e151101b5ee212b3575aa306a8970cca6b6231aae" => :high_sierra
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
