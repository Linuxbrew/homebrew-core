class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.4.6.tar.xz"
  sha256 "0fbc0f9282cffe85de99bc47bfa876525b9ddda2a2eae55c185a08804b98d3bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c65509e38cfa602e2b88c43372820e5e86af7d2d0828bd3fff28354bee9ed0e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f127dc3c9268fd68c96733b38baf424d21982d06d59974f9a74fb17b1780b46"
    sha256 cellar: :any_skip_relocation, catalina:      "e5613325c98a8b236ce7224153e550d9e32689897a5bce226462ba84c7cf6786"
    sha256 cellar: :any_skip_relocation, mojave:        "5a3368e77acd2829aa52e0f41e9cbd4047718b49ed10a568671d2136edf7ef69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d46a7db3fc335d7f052dea63be4109804c3acde0e237d3e43ea4de6f3d657f"
  end

  head do
    url "https://github.com/nim-lang/Nim.git", branch: "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  depends_on "help2man" => :build

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      man1.install "#{t}.1"
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
