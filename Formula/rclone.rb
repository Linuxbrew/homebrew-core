class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.3.tar.gz"
  sha256 "46fb317057ada21add1fa683a004e1ad5b2a1523c381f59b40ed1b18f2856ad0"
  license "MIT"
  revision 1
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9893c01fd98887fdb8a3f0172aa9f1c0c45772ef66745a035b2d59ed783a5a48" => :big_sur
    sha256 "7e0ac710208b82b5c40da947adebc35a97159d5ef6dae9bb77d5f9e147888a68" => :catalina
    sha256 "fb4f008464eeec2bc8351ae821109ab762bf67aa604952e5d362288af67d9b46" => :mojave
  end

  depends_on "go" => :build

  def install
    args = *std_go_args
    on_macos do
      args += ["-tags", "brew"]
    end
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
