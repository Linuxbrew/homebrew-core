class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/72/0e/664cce071e24e226d8c2322c1da40a5d364b02c7896d256ae8e9cfccffac/diffoscope-143.tar.gz"
  sha256 "a1fb4dd97af92bb8ce275d1caf465971726919e28efe5f043bd3ea9afb50574a"

  bottle do
    cellar :any_skip_relocation
    sha256 "71e7907c4f9bb2e3b466e3fdaf98d586a879718d7027539e6674ed989c8cf9a9" => :catalina
    sha256 "bc84739a6afd16a584e99f5cbb2350af5371606acedb19688fa9c2c6fe1e4480" => :mojave
    sha256 "5feacdd8d25405008ee0dc732baf0ebf6b68609b370e65c346e46b61b20e84c4" => :high_sierra
    sha256 "cd20512a6e521e348131af27d2d01c7f3decd718ffad8b685c245ec1e2e420a6" => :x86_64_linux
  end

  depends_on "gnu-tar"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.8"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/63/fe/9e6c78db381934e28c7ec3d30d4f209fe24442d17f1bd8c56d13ae185cf6/libarchive-c-2.9.tar.gz"
    sha256 "9919344cec203f5db6596a29b5bc26b07ba9662925a05e24980b84709232ef60"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/"libarchive.#{OS.mac? ? "dylib" : "so"}"
    bin.env_script_all_files(libexec/"bin", :LIBARCHIVE => libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
