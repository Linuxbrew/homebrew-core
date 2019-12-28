class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.7.0.tar.gz"
  sha256 "9cfb6be335f7a06ccaf7cc2a06075a23ed6e2e2fdd6ea7fbc165a7d4a30990f9"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "832c8447b349172f497612d7a6dfad41fe0bde9510d96bf51ad649998c4bf5b1" => :catalina
    sha256 "328b14e7636e4645720fb5f2e223ec4fa0199f4c59e569e1f6b08499e93d1d94" => :mojave
    sha256 "bb91fa56f066f0e39cbcf67f70073d20b9857f22bc09a8467bad2145a777585d" => :high_sierra
  end

  depends_on "rust" => :build

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    if OS.mac?
      assert_equal "\n~ \n❯ 2\n\n~ \n❯ ",
                   pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
    else
      assert_equal "\nvsts_azpcontainer in ~ \n❯ 2\n\nvsts_azpcontainer in ~ \n❯ ",
                   pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
    end
  end
end
