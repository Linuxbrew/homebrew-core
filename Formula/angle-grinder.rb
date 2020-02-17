# angle-grinder: Build a bottle for Linuxbrew
class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.13.0.tar.gz"
  sha256 "514e9edf033c633bf559f5cc3db365f3701f6d937d57a4e6718f525a20447bde"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e2295a6c25ad6937fc8db01bf0473887d941f4de5390465c91b0d3aa4366e06" => :catalina
    sha256 "0a866e3347ad9f8cdb4c811cea97d5f50ee78f0659fbf5be42f57d6d08cf7777" => :mojave
    sha256 "9ece027042fc01326c5a7b918af6c6284dda9de63c839905ee6e6e07a413a355" => :high_sierra
  end

  depends_on "rust" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
