class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.9.0/dune-2.9.0.tbz"
  sha256 "bb217cfb17e893a0b1eb002ac83c14f96adc9d0703cb51ff34ed3ef5a639a41e"
  license "MIT"
  head "https://github.com/ocaml/dune.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fa74cea5ac8d6c4a67cb034edceb0d72c187884b0cbd67abababa77cbd81b19"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f09b1e8ddf82fe3a684b4b770ef559dc65d63c3d8a3bae9472ab53c7de0011b"
    sha256 cellar: :any_skip_relocation, catalina:      "d5104b9a1a15dcf219e96fe3c51f55f9c22d13dabcf5b20fc6355b19613ca688"
    sha256 cellar: :any_skip_relocation, mojave:        "eff381531b552f4ca7b11a4e2e560a87175e7488ded036a4a95b6ca2e69303a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f722b67114acc23c3696d19c1df838564b807ad69060cc936fc766109b991c1" # linuxbrew-core
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
