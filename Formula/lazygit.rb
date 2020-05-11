class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.2.tar.gz"
  sha256 "ee99f77ae67129764835e6d85afd71a4f91c61a06952a891fe8fb46d8d5425e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6baa431a7322edcd2e86fc1bf46dc997e8f38bd0dc8df3606dcb5c4fe2d44c6" => :catalina
    sha256 "d8407f137d9c04b9c9d963ff161eb3d4433960eb1a7651656f9bf28556bfd5ec" => :mojave
    sha256 "c3818245476994213fcd40ffc2f492a251f947d29d94c589455bc4f546a11d9c" => :high_sierra
    sha256 "cbf5d5e674277d02b0b243450ff002643d5d60d99561cd9aa44cac8a6870d443" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
