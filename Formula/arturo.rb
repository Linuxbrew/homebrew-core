class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.7.4.tar.gz"
  sha256 "a7bd26b89fd5724bac38f9e9dd6a99147541c57099a5baca9590e02dabac46d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "50953778128a490881a216c3251970d668bc1c063e143ee8351decef0fd28e4c"
    sha256 cellar: :any, big_sur:       "b8210de3c8a54baca944a808583ba79046db3016c43f0ab56c88e5119998d304"
    sha256 cellar: :any, catalina:      "4b45bd192ec76edb3fb5d3947281f9920d52972349f959fc173ef4ddec2c74c3"
    sha256 cellar: :any, mojave:        "9a6519eb0a7784b0eea50e2239738985989f310eca8a2923f65237372dacea1c"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "install", "ROOT_DIR=\"$HOME/.arturo\"", "ROOT_DIR=\"#{prefix}\""
    system "./install"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
