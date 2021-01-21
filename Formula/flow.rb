class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.143.0.tar.gz"
  sha256 "d3701855c76f4266e3977b3d7bcf6ccfb7cacd920b4e8c24fca15012b3241448"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bf97246f062bd697e68870544bdc159e2fd99ca2b25599fedec02b83dbaa466" => :big_sur
    sha256 "86112563815bead6531ac1c6f8cba4365470e3604b42b2d8df662cdab6566ec1" => :catalina
    sha256 "4be113b4cd618548c4502d5e63d0168bdb1a3af1d74e3da9b204b0d04b94b028" => :mojave
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  unless OS.mac?
    fails_with gcc: "5"
    fails_with gcc: "6"
    depends_on "gcc@7"
  end

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
