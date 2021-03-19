class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/e3/62/feca720e7541356844c93fcf4d6b99c038158c10683a2f7f8456048ece85/b2-2.2.0.tar.gz"
  sha256 "7e924724a8946caaf60a17a27fc1deaebe704734b80c4f526cdd5fb2457a92c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52f659b8a78d0de151719d5c825cb25e140403b8c12810aaebed1204e3fa840f"
    sha256 cellar: :any_skip_relocation, big_sur:       "34fa612aab4c5a4a49dd9181f91809bfce0ad488ad4ab29b5803c24eea002845"
    sha256 cellar: :any_skip_relocation, catalina:      "009ec8478c59bb75b6cdfe0bbe257b7dfc6bb64561dac173e047852bd461adb6"
    sha256 cellar: :any_skip_relocation, mojave:        "be14ecfaf6ae68715d5b8144c0afae419c486ff72495c2f3f17d685d79b35ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e51bdcac6b15e665a96a5683fa1afc735446a3fda7c9534a4b77acada567b29"
  end

  depends_on "python@3.9"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/11/a9/b817612749e01b2450fa96d66cd2547e3de93aeb0e78dfe70887f48648e3/b2sdk-1.4.0.tar.gz"
    sha256 "fb82cbaef5dd7499b62622010fc8e328944ca8cbdd00b485530ab6600de1129d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/e2/a0/66a7b78e1800af85e54701490cf8764cc6de6c0725d18b10a6fb13ce4d2d/logfury-0.1.2.tar.gz"
    sha256 "42da58fbbd4e6fdb9e5b6b9098e94c249ba9cebfae125643329c8636768edcd3"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/ea/48/b1acdd934f89377fd047401f02c301b938f4962f5af30b8ad7224487c412/phx-class-registry-3.0.5.tar.gz"
    sha256 "f11462ac410a8cda38c2b6a83b51a2390c7d9528baef591cb5b551b11aba2a92"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ef/58/60cc1e9af5714d1b86062f6dc00c5dd6973c902da6259f930b9c6e7a3430/tqdm-4.59.0.tar.gz"
    sha256 "d666ae29164da3e517fcf125e41d4fe96e5bb375cd87ff9763f6b38b5592fe33"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
