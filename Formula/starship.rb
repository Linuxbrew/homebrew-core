class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.55.0.tar.gz"
  sha256 "34d63db5d34d6150cd62a5fa1333ab8922b7381ffb15ca8e6e2d5b4f9b79c4d5"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "566f8ce22709faf4b7984482b1379c6481540b4d904c285feccc6894a15d1a26"
    sha256 cellar: :any_skip_relocation, big_sur:       "e64f01ffb5fa4ac17f9cc5a66ef3a23f8009701af186bdd3b713641250dc278d"
    sha256 cellar: :any_skip_relocation, catalina:      "1c1f66391875a83830b383691dbca271746acd08a7603102f2af6fdaf6b03b99"
    sha256 cellar: :any_skip_relocation, mojave:        "d1818c378fe6916aea8c58a0bbcda9877da07db26610079771269bfa58807e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0daa09c8dc76875ed2f0b24f8a40c76ad35f3b9cc141dcb5fa73ae415ee0de" # linuxbrew-core
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
