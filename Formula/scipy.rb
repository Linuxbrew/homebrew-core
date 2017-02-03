class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "http://www.scipy.org"
  url "https://github.com/scipy/scipy/releases/download/v0.18.1/scipy-0.18.1.tar.xz"
  sha256 "406d4e2dec5e46ad9f2ab08620174d064d3b5aab987591d1acd77eda846bd95e"
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 "07ce1e43b9985be7728cd5e381bbcf4cd523d3fabbb309385ef14020874b8d2e" => :sierra
    sha256 "21a66c03485a690bd4768099aedfe8b3830a7806d82f7f82c5b0e242a7bb8d36" => :el_capitan
    sha256 "821b54bc33725fdb46970ef2cba2d7fc68492fe930078d2ba1b5d3303af7ba8f" => :yosemite
  end

  option "without-python", "Build without python2 support"

  depends_on :fortran
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional
  depends_on "swig" => :build

  option "with-openblas", "Use OpenBLAS instead of Apple's Accelerate framework"
  depends_on "homebrew/science/openblas" => (OS.mac? ? :optional : :recommended)

  numpy_options = []
  numpy_options << "with-python3" if build.with? "python3"
  numpy_options << "with-openblas" if build.with? "openblas"
  depends_on "numpy" => numpy_options

  cxxstdlib_check :skip

  # https://github.com/Homebrew/homebrew-python/issues/110
  # There are ongoing problems with gcc+accelerate.
  fails_with :gcc if OS.mac? && build.without?("openblas")

  def install
    # https://github.com/numpy/numpy/issues/4203
    # https://github.com/Homebrew/homebrew-python/issues/209
    # https://github.com/Homebrew/homebrew-python/issues/233
    if OS.linux?
      ENV.append "FFLAGS", "-fPIC"
      ENV.append "LDFLAGS", "-shared"
    end

    config = <<-EOS.undent
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
    EOS
    if build.with? "openblas"
      # For maintainers:
      # Check which BLAS/LAPACK numpy actually uses via:
      # xcrun otool -L $(brew --prefix)/Cellar/scipy/<version>/lib/python2.7/site-packages/scipy/linalg/_flinalg.so
      # or the other .so files.
      openblas_dir = Formula["openblas"].opt_prefix
      # Setting ATLAS to None is important to prevent numpy from always
      # linking against Accelerate.framework.
      ENV["ATLAS"] = "None"
      ENV["BLAS"] = ENV["LAPACK"] = "#{openblas_dir}/lib/libopenblas.dylib"

      config << <<-EOS.undent
        [openblas]
        libraries = openblas
        library_dirs = #{openblas_dir}/lib
        include_dirs = #{openblas_dir}/include
      EOS
    end

    Pathname("site.cfg").write config

    # gfortran is gnu95
    Language::Python.each_python(build) do |python, version|
      ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
      system python, "setup.py", "build", "--fcompiler=gnu95"
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    Language::Python.each_python(build) do |_python, version|
      rm_f Dir["#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages/scipy/**/*.pyc"]
    end
  end

  def caveats
    if (build.with? "python") && !Formula["python"].installed?
      homebrew_site_packages = Language::Python.homebrew_site_packages
      user_site_packages = Language::Python.user_site_packages "python"
      <<-EOS.undent
        If you use system python (that comes - depending on the OS X version -
        with older versions of numpy, scipy and matplotlib), you may need to
        ensure that the brewed packages come earlier in Python's sys.path with:
          mkdir -p #{user_site_packages}
          echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
      EOS
    end
  end

  test do
    system "python", "-c", "import scipy"
  end
end
