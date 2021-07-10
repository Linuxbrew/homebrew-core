class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.9.8.tar.gz"
  sha256 "0c464c3a06d40e68e1014e583ec1733aa16bca5796fb42874438dec9f4a464a4"
  license "CC0-1.0"
  revision 1
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d4873eea03a17e75633c10ef17866f0c0874fecedcf12a42a681b80888cc3f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "a37648ce7842c0ceb710afefb07ca09b5d4172fc586ccd0a0ae55b330380fbc4"
    sha256 cellar: :any_skip_relocation, catalina:      "f50603fde712aafd815ff5ef16b1c7f56c25262d9a9d7fc5bf6c670d4b95a0e0"
    sha256 cellar: :any_skip_relocation, mojave:        "f0d5b95f168fb896b090d90724afec42510becae4f188a671b7ec1f0c668e33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd311942ff1a89beb46a740edefdfce5cd5ca6f3b72ebbcc2983bf7218c9bb6" # linuxbrew-core
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
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
