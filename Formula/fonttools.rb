class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/8b/ca/f4003975840fdd68aafbb45bf04f95f6efdb15002bd330db5e45609d11ff/fonttools-4.22.1.zip"
  sha256 "fea6bb9d1d23a94d5e8fa6238214538a89d4333e340025a95a16b77ddb191e6f"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5589ef5b8244b1d46b5041f46d310577511888d0f3381eeae03110c8044f066e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d85f673b819b68d0789e869134790dc0d774ce28ee2c74a5db9abef769081e96"
    sha256 cellar: :any_skip_relocation, catalina:      "d85f673b819b68d0789e869134790dc0d774ce28ee2c74a5db9abef769081e96"
    sha256 cellar: :any_skip_relocation, mojave:        "6dc02159bbb1cbaf5abd44d5cfab2b114b14d11e4435ad2e8753997f99038f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e83d2800274619afb3911d271450903bdcae687df9aca9272e0dc3e8ab7b3c"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
