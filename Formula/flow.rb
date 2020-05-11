class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.124.0.tar.gz"
  sha256 "d9b2f56e5bb3e88e43c14ee5620bbc9d3a8db9e22d02731d48662a9d7ae73629"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51909b235a97efb6a93dd21729b0c1470b8d0d3a871e2d7f5f9d16a2f59d5f24" => :catalina
    sha256 "e829fc98abd5a9dda77b4df68c5b7b23554356461084ba7ae0f51e6e58b3daa3" => :mojave
    sha256 "b42b64a23cc102228fed2d7f282ab81ebd1cfbb04e0afb93a683b92b429fd0d5" => :high_sierra
    sha256 "d4e48b153fc42ab686b7a815151924808ad9c100ec430af1ee19108aac3e2e51" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  unless OS.mac?
    depends_on "rsync" => :build
    depends_on "elfutils"
  end

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
