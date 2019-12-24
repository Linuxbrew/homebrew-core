# ghq: Build a bottle for Linux
class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.17.0",
      :revision => "bb059e45e72c30b28e38fbadbda29dca71f8d04a"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8da0ab956de454c8810c24458a4cc6f2ad2afc256f8970bc9562fc0f46ea6c3" => :catalina
    sha256 "2b792533de6f9fa46e49ecf416d625d75e5804346e98e00e488208efbf5b1b7a" => :mojave
    sha256 "e4fb6e0b8723e7933a0445454d2a8d3563a4baae8c09cc4be92f2368560105b0" => :high_sierra
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
