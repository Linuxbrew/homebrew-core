# ghq: Build a bottle for Linux
class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.13.0",
      :revision => "7ba9b5f82952dc930f289262a2df7bafb6bd53bf"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d545df8a37b72bd5fb83ac25b19c1c76251242871764dcbdc19d8c02aeca93" => :catalina
    sha256 "153f6cfba03d83a63ddaf1fc74a85f54b346bc59de5c915d830120745dc65491" => :mojave
    sha256 "dade6cea71dcb604626ea931a1decbb156216e396801cd57e3fc808bddabc15e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
