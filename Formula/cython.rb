class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/99/36/a3dc962cc6d08749aa4b9d85af08b6e354d09c5468a3e0edc610f44c856b/Cython-0.29.17.tar.gz"
  sha256 "6361588cb1d82875bcfbad83d7dd66c442099759f895cf547995f00601f9caf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d5f602ee1ab8b1af6b5992fa2d93f13c51823a061d250c8727d5f081694a3e8" => :catalina
    sha256 "6a5699fa8fca4e5ab27bd58f344df97ee28fb23b683eb72e01822375e6f76b7a" => :mojave
    sha256 "797a5c3ef1ccd26d6e6b9f4aa83d49e5ad4da78b7265e6134406d67b8d3dffe3" => :high_sierra
    sha256 "4f67b1b8dce9b4f731d7b91ba908935272f43c462bbe7240f1ec4563c4fce690" => :x86_64_linux
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{Formula["python@3.8"].opt_bin}/python3 -c 'import package_manager'")
  end
end
