# navi: Build a bottle for Linux
class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.15.5.tar.gz"
  sha256 "2ce8c7053fd5483c95d5b1be4a6cc02a7156c6f7e14d415d3d3b83011c2a37ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :catalina
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :mojave
    sha256 "32903c06380df0c28f55236b09cbf52fd41643ed8b7a23a95679608c020ee403" => :high_sierra
  end

  depends_on "fzf"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_equal version, shell_output("#{bin}/navi --version")
  end
end
