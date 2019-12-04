# ghq: Build a bottle for Linux
class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.13.1",
      :revision => "fffc1e53c18c29a46eb4347d2827158550d1c375"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90465b7214698d15dfe35d697b53d96dc9ec8094221bc4e1cf9314be6b054ec6" => :catalina
    sha256 "8c189936f46e984e16ad8c170b6acf45156f97a440bfe6ca88def3f811005d15" => :mojave
    sha256 "d8766defc2c1e55634d0235e2ab084de69fc5118511aaf568a67695fb8d35f11" => :high_sierra
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
