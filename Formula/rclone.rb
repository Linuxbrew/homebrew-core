class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.0.tar.gz"
  sha256 "8dda3015e2230bc6bc768b0ef85069022d69b6863bcbae15f3949782587cf92f"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75ea50379b300e690fc2781f34b76c7620ecfef2d26bed7a44f3012d951f8f9d" => :catalina
    sha256 "48125279f9c329c0a220f90e79ca7ee26960fd155ccd80bf6c2671e54611cf7f" => :mojave
    sha256 "60dc37c16c258f68a792fa5507f97c0fc90898f1478643d7527880b72406c4c2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
