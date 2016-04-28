# sphinx-doc: Build a bottle for Linuxbrew
class SphinxDoc < Formula
  desc "Tool to create intelligent and beautiful documentation"
  homepage "http://sphinx-doc.org"
  url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.4.tar.gz"
  sha256 "0ffb35263dbc7b6f3e5fdadc33815ae859e31bf1070226be52448cd43cd3ceeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f3a3ab0c4106d1e2ef3248ae95550234b285f4339bed73e7c4445dd8473cd5a" => :el_capitan
    sha256 "981eef30ad42a1bfb04ddc2aec53dfbbfb7e4acc6797b0371e0a25c89e56eec5" => :yosemite
    sha256 "96f89a5d05cb08afeb9f847be349f05d706b4484bf94bd5693bc9319f4fd9352" => :mavericks
  end

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc.
  EOS

  depends_on :python if MacOS.version <= :snow_leopard

  resource "alabaster" do
    url "https://pypi.python.org/packages/source/a/alabaster/alabaster-0.7.7.tar.gz"
    sha256 "f416a84e0d0ddbc288f6b8f2c276d10b40ca1238562cd9ed5a751292ec647b71"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.2.0.tar.gz"
    sha256 "d8cb4c0e78148aee89560f9fe21587aa57739c975bb89ff66b1e842cc697428f"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "imagesize" do
    url "https://pypi.python.org/packages/source/i/imagesize/imagesize-0.7.0.tar.gz"
    sha256 "bb3d10fca0f66f771298d19035d8e6d01aaafb9ec8d9ae972dcb8acb2cf94f57"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2016.3.tar.bz2"
    sha256 "c193dfa167ac32c8cb96f26cbcd92972591b22bda0bac3effdbdb04de6cc55d6"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.1.tar.gz"
    sha256 "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"sphinx-quickstart", "-pPorject", "-aAuthor", "-v1.0", "-q"
    system bin/"sphinx-build", testpath, testpath/"build"
    assert File.exist?("build/index.html")
  end
end
