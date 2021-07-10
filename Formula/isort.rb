class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/ac/2a/87e6a7d3c3953ddfb37c6da3fd951490425a60d2ab0be059b321d5788dc8/isort-5.9.2.tar.gz"
  sha256 "f65ce5bd4cbc6abdfbe29afc2f0245538ab358c14590912df638033f157d555e"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "782fbf745d76bc86201818718026f50e24c16e4b7e48e39e0087539195b49319"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9d947b55140ca255b947f96e77bb796619f4fc3e974e57f4defde87764e677a"
    sha256 cellar: :any_skip_relocation, catalina:      "7ca3e49c222871b0bb91520b180abf4ebf953b4f3aac7eab36cb67e710cbc24e"
    sha256 cellar: :any_skip_relocation, mojave:        "f9527c060b4d71740227719b26a43637d309d6c59c0567253aeca048508ba923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be1bc03a567bfb8ab867db8abe7236c693be52cce9485860ce51d81faa366d8" # linuxbrew-core
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
