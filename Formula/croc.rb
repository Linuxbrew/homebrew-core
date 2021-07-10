class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.2.0.tar.gz"
  sha256 "e8f72be7f3c26a1c4ed00c3ebb222d2959cd6c7f7f74a097a556b56e6a24ba96"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8d2bce997286608887c5de5fa88a489e58a3589e03da8ce6a56e2932b80cbc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f2380eed7e43e12c8351b4f888a413c132f7d0368c51f7bdc19d784cfb5343d"
    sha256 cellar: :any_skip_relocation, catalina:      "648abc127e2e14010beae1e4238ebfd181bb84e92bdcaac9e8aa85247b710827"
    sha256 cellar: :any_skip_relocation, mojave:        "7d8246133db4e8b79a53f58b2173f21449b78ba0f5dca344213ab094a36afae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eec14f50a1837be6dc7bc82fd22aff62809982397d3142fac9f9e6d18d3315b" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
