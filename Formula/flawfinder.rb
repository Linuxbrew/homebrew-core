class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.18.tar.gz"
  sha256 "6a51efd7869e0f36a00f33455ec2d1745dc36121130625887b4589e646f062c2"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2543426a3f0c9fce88f8e1ef6dac28f553c1ffbcc5507f1bff4f751179c4eb76"
    sha256 cellar: :any_skip_relocation, big_sur:       "12a152169ad256368cb53f466fb7cdfa0ef30a8e214d71226a90e6dd038a3303"
    sha256 cellar: :any_skip_relocation, catalina:      "12a152169ad256368cb53f466fb7cdfa0ef30a8e214d71226a90e6dd038a3303"
    sha256 cellar: :any_skip_relocation, mojave:        "12a152169ad256368cb53f466fb7cdfa0ef30a8e214d71226a90e6dd038a3303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2543426a3f0c9fce88f8e1ef6dac28f553c1ffbcc5507f1bff4f751179c4eb76" # linuxbrew-core
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "flawfinder.py"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int demo(char *a, char *b) {
        strcpy(a, "\n");
        strcpy(a, gettext("Hello there"));
      }
    EOS
    assert_match("Hits = 2\n", shell_output("#{bin}/flawfinder test.c"))
  end
end
