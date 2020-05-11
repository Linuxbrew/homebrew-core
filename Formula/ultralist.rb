class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.5.tar.gz"
  sha256 "60228adc4506b5f99ac8786acf0927c6898f9b945f2dce2e86188842485e9615"

  bottle do
    cellar :any_skip_relocation
    sha256 "c168f39c6e31967eacc9f515291d6343b3e01817e3f0a0ffba54365688c1f4d5" => :catalina
    sha256 "296b3ed7d73af21af700ec4e04e68a624112c3efdd516ce04486eb3e5263a18d" => :mojave
    sha256 "2c1e5a2b4839188342c2d4dbf2cc199a9f1940c4084a0e1c58413c572ce26f8b" => :high_sierra
    sha256 "9039b1489ad85ad19239ed92e89ca736ce920b860a057c8e15a6b0df540ae8f6" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ultralist/").mkpath
    ln_s buildpath, buildpath/"src/github.com/ultralist/ultralist"
    system "go", "build", "-o", bin/"ultralist", "./src/github.com/ultralist/ultralist"
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
