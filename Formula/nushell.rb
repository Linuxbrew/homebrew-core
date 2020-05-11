class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.13.0.tar.gz"
  sha256 "a07f730fa5dfe96ea3104b1cc13d2e72951a754870f22fb0dac6e30a359c6d8e"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f4c3ea588dd7578d63e5fb3cac4effa54a663fc267652b62a28ba9d131a3bc3" => :catalina
    sha256 "aae3eabe041dded3b75543c9ed9bf640d447ef6d7e8700134df95bd0689f768d" => :mojave
    sha256 "355bd7c50f4898e1bd4ef0562410022afee9dbfaa7cbb5df95761b87694e37bc" => :high_sierra
    sha256 "e161c492667fad81ac2fd6f614fc9679b40b8fde28550b7be4962fc7657ef184" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "linuxbrew/xorg/libxcb"
    depends_on "linuxbrew/xorg/libx11"
  end

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    if OS.mac?
      assert_equal pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it'),
      "Welcome to Nushell #{version} (type 'help' for more info)\n~ \n❯ 2~ \n❯ "
    else
      assert_match "Welcome to Nushell #{version} (type 'help' for more info)\n",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
    end
  end
end
