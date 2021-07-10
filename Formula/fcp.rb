class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a90158d049b5021f60d31eb029daf74a72f933b73bf867b5f6b344be83d69fdc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c75727a5e1b12878e6b87d7fe02c93fc1ef83fdbfefdf86c0b1dbb6954734289"
    sha256 cellar: :any_skip_relocation, big_sur:       "87520494288bf64154cea98f5f63dd4ff0d7b8d1b8084d6ebd0f416bf6d4b45b"
    sha256 cellar: :any_skip_relocation, catalina:      "23280cce3a5305571eba38dd7d935259295a273bb95e5ee9e21687cc7f78a783"
    sha256 cellar: :any_skip_relocation, mojave:        "cbb1bb6442ca303c9a81ded3c8c536238619857421a329f48fbb0ac2a62e8738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4efd3f5556bf69f0692af9630a92e65d9a61879920e00de6761185b0138996e" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src.old").write "Hello world!"
    system bin/"fcp", "src.old", "dest.txt"
    assert_equal (testpath/"src.old").read, (testpath/"dest.txt").read

    (testpath/"src.new").write "Hello Homebrew!"
    system bin/"fcp", "src.new", "dest.txt"
    assert_equal (testpath/"src.new").read, (testpath/"dest.txt").read

    ["foo", "bar", "baz"].each { |f| (testpath/f).write f }
    (testpath/"dest_dir").mkdir
    system bin/"fcp", "foo", "bar", "baz", "dest_dir/"
    assert_equal (testpath/"foo").read, (testpath/"dest_dir/foo").read
    assert_equal (testpath/"bar").read, (testpath/"dest_dir/bar").read
    assert_equal (testpath/"baz").read, (testpath/"dest_dir/baz").read
  end
end
