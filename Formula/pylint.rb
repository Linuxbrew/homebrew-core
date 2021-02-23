class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/62/a7/5c6587dd61fc6c759f36a535c0a42090ae0d81f9b142950bdafdb3bc0ccc/pylint-2.7.0.tar.gz"
  sha256 "2e0c6749d809985e4f181c336a8f89b2b797340d8049160bf95f35a3f0ecf6fc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28995351b2fb375ac16de539b71289320914fe13ebbb1edbf06ba6476a274928"
    sha256 cellar: :any_skip_relocation, big_sur:       "d93a3c97ba70949904973e84d4181fc9df07231d2e83fa1d8ef8dce19aa15136"
    sha256 cellar: :any_skip_relocation, catalina:      "49b9dba8d123d15cb990160d135856e566e881aedaf941bbbf9181809630ccf8"
    sha256 cellar: :any_skip_relocation, mojave:        "c65f990a62586e1148699235bcf7cc01ece9f5f1a52a13eb800db9247da80edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e02d18b07cd9d92440d94885e682bff188fc27489413266baf8136aaf305609f"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/18/00/753b485627d9cd642516c195db63dcc0c87c36b8c682125c000b7f611b09/astroid-2.5.tar.gz"
    sha256 "b31c92f545517dcc452f284bc9c044050862fbe6d93d2b3de4a215a6b384bf0d"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/a2/f7/f50fc9555dc0fe2dc1e7f69d93f71961d052857c296cad0fb6d275b20008/isort-5.7.0.tar.gz"
    sha256 "c729845434366216d320e936b8ad6f9d681aab72dc7cbc2d51bedc3582f3ad1e"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/95/b7/8823606ab25245effb6907fd7699f2234ae0bbd39e0c7b10b84def966f45/lazy-object-proxy-1.5.2.tar.gz"
    sha256 "5944a9b95e97de1980c65f03b79b356f30a43de48682b8bdd90aa5089f0ec1f4"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
