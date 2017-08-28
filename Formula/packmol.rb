class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.221.tar.gz"
  sha256 "b5dcdeb694ffc17f620a4517e4eba67018145774d6fa06c4076bfbfe79400407"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar :any_skip_relocation
    sha256 "6668bde18b3bb98332f2d6fa3ad5cbab1128983aabbbbd0caa6168bc6f1dd5a3" => :x86_64_linux # glibc 2.19
  end

  depends_on :fortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
