class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.5.tar.gz"
  sha256 "8b252a71308fd71d9735f9a9eb221365f04695ba6961d4035e22c3ec00a50f93"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a39b3a4b2b0d742d66a4bece9ed38ec178f3740f645a2682966cf66471799f63"
    sha256 cellar: :any_skip_relocation, big_sur:       "85b4ac007a97d2654761e2e7aacbf6433d763e65a9a8f2b46f2dff3f8166e9b5"
    sha256 cellar: :any_skip_relocation, catalina:      "2128a6050652de4c87b97b7d4194b9bfbe063cbaaa823640d2b4c778e98266fd"
    sha256 cellar: :any_skip_relocation, mojave:        "5d2656cdbf62c300cfdf147d1aac16b45edc49a8fc613ad35ab0501ad11cfd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7759a5f784ade19a5f4a57b90fa4c10282a1eb66dcd410d5deabab05d1079c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
