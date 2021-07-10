class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/3d/ff/eb45fbc169f9aac6d9798933ad1b624e5d01c2191efc0134d8014e20b4a2/lizard-1.17.8.tar.gz"
  sha256 "da8f62b478b9b2fffcddba274259b79bacce7509ccc14e1074cb54516d5ade15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f448055736149c8292402df3e40cef3e45a6799dba306607a503a42992ca3f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
    sha256 cellar: :any_skip_relocation, catalina:      "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
    sha256 cellar: :any_skip_relocation, mojave:        "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c734f9d1cdf2ba37e84a539724002a323498af5328471fb99eee801cf555e7" # linuxbrew-core
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    EOS
    assert_match "1 file analyzed.\n", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
