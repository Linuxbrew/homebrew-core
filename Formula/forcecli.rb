class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.28.0.tar.gz"
  sha256 "96e2b3c30cbd576f3bf55ee523103029ca43d96d8b08418d797531ebc5dc6de8"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "105f254bfdca41b245d460591535c51cd8bdd1ffa72ec699085541f91deb9e60" => :catalina
    sha256 "ebd7fabbe0844a821e50bc76ccf29bde7c6fffe14c1fc6fde7546d18d4828ac8" => :mojave
    sha256 "60c1ad2bb51a2576d4a9927754ab5fc290de56138eda881832aa501615d5e654" => :high_sierra
    sha256 "c33a38a02abf8a9108aabcd2957d843bf0e9dd93df64751176f1bf7c318cf770" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
