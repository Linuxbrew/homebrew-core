# ghq: Build a bottle for Linux
class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v1.0.2",
      :revision => "3981090302a12b29c0c96736fc0aafe5a83a109d"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab8b83cdeae93df6c559b746f9df16b09accc6c786e1af2e49e892e98cafff6d" => :catalina
    sha256 "244d21e403801060092f418dc5135612ec7126083c75f1aa2bf8b5e06d3848b2" => :mojave
    sha256 "8b22664af8e9cc78aea2d4fc8d84ce4fa5fc4430b3af75d74dd7e0dc833db104" => :high_sierra
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
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
