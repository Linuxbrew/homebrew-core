class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/v1.1.tar.gz"
  sha256 "d13603d64ccaae741c1c7d4448ef4422d4c1299f31042ed57f78d4bb8a93c6e7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf0101431535e6c61e34269f05d3b1b93fdd03c4617644d99a901299c5edbb05" => :catalina
    sha256 "41f5bc28ad62eaccaa2e968d0abd0bf5e1fe5dd90967c49d4df156dcd8b1c5dd" => :mojave
    sha256 "e257c3dd6ec86db47e4b8a8444d0edb4ec212f96de2c9a762c87727a0ee668e0" => :high_sierra
    sha256 "e3f5f94e0059b588ff8ebc6434f8f2cd37f2fc82d2942fa2b392ff38832e6345" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
