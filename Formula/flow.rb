class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.155.0.tar.gz"
  sha256 "020e3a02e959f6b13263e43af899f2896a16a389650946dfd5b82c02c9bdea83"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "155ee53ef9bbac119ac6a9fd6798b2012cda7c6c0d3642d24f0a7e2694fc3e32"
    sha256 cellar: :any_skip_relocation, catalina:     "4bf4210e32af7e4b0143f95c619845f6f19715afad400d3d03e4781c6f42654f"
    sha256 cellar: :any_skip_relocation, mojave:       "580e7fe2ceb281dbdb155ce82c1b733065b5700ba9093ff359db857187aae834"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc66abb89a4a128ef67478e7b030feb7f83ef332a371ca0991e89071d1394234" # linuxbrew-core
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
