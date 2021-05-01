class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v1.4.0.tar.gz"
  sha256 "71a71a801255badfe9d24d47d8ae7b9d3ed0a889a78b977c39d0c65091078155"
  license "MIT"
  head "https://github.com/so-fancy/diff-so-fancy.git", branch: "next"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e93e7878b60a2a30e8c699caedb06e79c9a623c7f30de1e3a49277b51377bf0f"
  end

  def install
    libexec.install "diff-so-fancy", "lib"
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    diff = <<~EOS
      diff --git a/hello.c b/hello.c
      index 8c15c31..0a9c78f 100644
      --- a/hello.c
      +++ b/hello.c
      @@ -1,5 +1,5 @@
       #include <stdio.h>

       int main(int argc, char **argv) {
      -    printf("Hello, world!\n");
      +    printf("Hello, Homebrew!\n");
       }
    EOS
    assert_match "modified: hello.c", pipe_output(bin/"diff-so-fancy", diff, 0)
  end
end
