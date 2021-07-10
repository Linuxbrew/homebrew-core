class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/92/42/d7d003aeac12d74a482d5a69eb9870cd6e82118a6a35dd5e1927503f4a9d/gallery_dl-1.18.1.tar.gz"
  sha256 "1e231ed7122a753430d92f8c6240a99defa2b307d57f1a4cc3e48910269331a9"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8cda39043f9ff23c2046350edee63a8c43b170c36606982e4e73901abfaa10e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9abbbeaaea0ec424b8f25b6d38e07ef1cf8e313b3e772e5f945a98197e85b728"
    sha256 cellar: :any_skip_relocation, catalina:      "9abbbeaaea0ec424b8f25b6d38e07ef1cf8e313b3e772e5f945a98197e85b728"
    sha256 cellar: :any_skip_relocation, mojave:        "9abbbeaaea0ec424b8f25b6d38e07ef1cf8e313b3e772e5f945a98197e85b728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca1cf11de6d200bef59ba5107029026e84b295a1fd09d853d09e13fdcd2056d" # linuxbrew-core
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
