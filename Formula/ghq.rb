# ghq: Build a bottle for Linux
class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.17.1",
      :revision => "5add27b66cbb918e28f195a9065f6875b1a33392"
  revision 1
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b049947bba0792be5adc935ae4e2419a6b59b0ca2e4ce212ef8ab000fcd78e1" => :catalina
    sha256 "9cecceec484eb2b8ccc0d9c626771e7a4217ea9c0b9515432b9dd8ccc241a5d1" => :mojave
    sha256 "9e55e0e171b7f3b3e7b774caaf7962d79480184c07b9500cf4c0620f3b2d73f8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
