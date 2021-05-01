class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ca/5d/c746f030903a75fd428851560f2895a16a5065ed53a69c232c4beb0eafb4/virtualenv-20.4.4.tar.gz"
  sha256 "09c61377ef072f43568207dc8e46ddeac6bcdcaf288d49011bda0e7f4d38c4a2"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e769fbd676d5d178436dc69744702e1c449aa9b7b5036ee6cc0f7ecc415cc4f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3a77f3f04d64ab6173f0d22f2da3014830148c739865b36edc5bea0d82892c1"
    sha256 cellar: :any_skip_relocation, catalina:      "117e64ef63afe93b83e22403926cbe1b9bb1840d7956af7881e7319e3cc03c2a"
    sha256 cellar: :any_skip_relocation, mojave:        "2bd53c13f621b286dd96a1a833bbd876224c91348e2f9c50dd7cbab87e215483"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
