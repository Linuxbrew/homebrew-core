class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.23.2.tar.gz"
  sha256 "ca59e61612c7e9892a1744dfd269884801ce0093708f420b6b321b3a0544bbef"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "a57a2ea3b63e05448bb8e1c59771e167f8dda0e5ef87f72acfc9339908276689"
    sha256 cellar: :any_skip_relocation, catalina:     "4b4b957337cf19a1a78dbf8e61399a66bd8a89c09a055e8c9bf1829962299752"
    sha256 cellar: :any_skip_relocation, mojave:       "fab982e37191aefce3f86cdaeebad1aa8096a5f93a9fe1f91b8f8d3d5d4be7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "103633bcc6d3a6aba1fe415813de6c95c6a9b60f0ab2616f70b3c738c812f962"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
