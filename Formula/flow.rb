class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.133.0.tar.gz"
  sha256 "74d56309b800feaded794fb19492005617266cb33da078c2811abd60603a4a86"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33676e1f00b63da0d5cca3db2304f8fb0913a39c86c788696986629e611b7cc9" => :catalina
    sha256 "e94d74b743ea057b376e3da652f61bd524031ceddc056b54e0a102aff7ec3d4c" => :mojave
    sha256 "723601f92a5463dd556cffcd871ee35dcaffad3ab29f49f69788a09e09cce805" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
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
