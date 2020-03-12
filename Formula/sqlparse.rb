class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "439ec9e76d4cb0bd66dde0e9bd3cf471d0c067ae19e5ccac0d8fcfaee0f08d62" => :catalina
    sha256 "a3f4a494651de7aca86d4743e9a54a2ba9209d4ca4785deaf21d6da51512ae63" => :mojave
    sha256 "73dbdb834b2d5cd10bf0629f7c7fe9631e3eda5b8a704c2b65e278f5ad94b741" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
