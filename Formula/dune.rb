class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/2.5.1/dune-2.5.1.tbz"
  sha256 "8f77d3a87f208e0d7cccaa1c48c4bb1bb87d62d07c3f25e9b8ba298e028ce52b"
  head "https://github.com/ocaml/dune.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ad564f2f5163e093731c46e69ce3db54360e82d401846492554590076a879e6" => :catalina
    sha256 "683762ae633810561186d9373c574b7a469367c2105869ed886f4e035627de13" => :mojave
    sha256 "40a1316220c898a1ae98ca9f5445d5b4f2566a83904b188a3018f7228fb193fb" => :high_sierra
    sha256 "12d8878c4ee6fb8dbf664e803504de5174e57eb5b2ef914e2545a405d2e537bb" => :x86_64_linux
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "ocaml", "configure.ml"
    system "ocaml", "bootstrap.ml"
    system "./dune.exe", "build", "-p", "dune", "--profile", "dune-bootstrap"
    bin.install "_build/default/bin/dune.exe"
    mv bin/"dune.exe", bin/"dune"
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
