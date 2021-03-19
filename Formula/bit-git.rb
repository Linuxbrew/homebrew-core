class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.0.4.tar.gz"
  sha256 "2c8edfae9113f35bc767a58d0e473a3b9bc26c88d60118ec581a5d481771100c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "687fc0b96f9eacceec5dba5014397eb5a9fa2efad47a770914df65a34339921b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1c634bb430bb01cf111ffcf136482751af401d9cb9c6542b2f7534247c53f38"
    sha256 cellar: :any_skip_relocation, catalina:      "06c1ee6d6ddfc04c8e40524a46dc70e0adb866fbfa6d4702dc1055b430c3a72b"
    sha256 cellar: :any_skip_relocation, mojave:        "b9ed1472241f09279f4ff6371d04f91263fe118d6349173173434ec39609c23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec4d8b3b57e9692675278cbf8e9fbc47df727523911d68985d55a6cb7155985"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}"
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
