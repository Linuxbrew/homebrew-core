class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.0.2.tar.gz"
  sha256 "87c832b25794d7acac2fa4bd3389c81819535f32242d5e99284da76a1a86f1f3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b49b821d246cb6d14ee07a15e78220a94840eed6ed0e69f61a6e22546c05ca9" => :catalina
    sha256 "ef318fc3e0335589b1ad5aa1c61b50907510b5cae4e58dd027d8bed8ec927f6e" => :mojave
    sha256 "e05440e9dc3e6e9002442dd6c3bd1e2126e253de85ef2591219ce43f0d7eac2a" => :high_sierra
    sha256 "77e5b0cf9bcfb3354dc21caebaee8f77bb66fc665d2625a73baf4a380301abf8" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", :because => "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
