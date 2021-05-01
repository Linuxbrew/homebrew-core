class EasyGit < Formula
  desc "Wrapper to simplify learning and using git"
  homepage "https://people.gnome.org/~newren/eg/"
  url "https://people.gnome.org/~newren/eg/download/1.7.5.2/eg"
  sha256 "59bb4f8b267261ab3d48c66b957af851d1a61126589173ebcc20ba9f43c382fb"

  livecheck do
    url "https://people.gnome.org/~newren/eg/download/"
    regex(%r{href=.*?(\d+(?:\.\d+)+)/eg["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74568f637220ed13d0868c14a6efb65d559dc30a5db715d1e2fa956f7a2cc123"
  end

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
