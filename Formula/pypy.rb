class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy2-v6.0.0-src.tar.bz2"
  sha256 "6097ec5ee23d0d34d8cd27a1072bed041c8a080ad48731190a03a2223029212d"
  head "https://bitbucket.org/pypy/pypy", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "6dcfb7237a5e140e1553ed17765e831d9011ab9b94cab7ef17afe03b5ff73843" => :high_sierra
    sha256 "0ed2c2f9624ca5bbd48bc730378304ddfc22838edeb566c461ce574deba311df" => :sierra
    sha256 "639304dfa0d74fef27ad2566ececf3514288a87e471fb5f147ae4726c0a1f798" => :el_capitan
  end

  option "without-bootstrap", "Translate Pypy with system Python instead of " \
                              "downloading a Pypy binary distribution to " \
                              "perform the translation (adds 30-60 minutes " \
                              "to build)"

  depends_on :arch => :x86_64
  depends_on "pkg-config" => :build
  depends_on "gdbm" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "openssl"
  unless OS.mac?
    depends_on "expat"
    depends_on "libffi"
    depends_on "tcl-tk"
    depends_on "zlib"
  end

  resource "bootstrap" do
    if OS.mac?
      url "https://bitbucket.org/pypy/pypy/downloads/pypy2-v6.0.0-osx64.tar.bz2"
      sha256 "d7dc443e6bb9a45212e8d8f5a63e9f6ce23f1d88c50709efea1c75b76c8bc186"
    else
      url "https://bitbucket.org/pypy/pypy/downloads/pypy2-v6.0.0-linux64.tar.bz2"
      sha256 "6cbf942ba7c90f504d8d6a2e45d4244e3bf146c8722d64e9410b85eac6b5af67"
    end
    version "6.0.0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/1a/04/d6f1159feaccdfc508517dba1929eb93a2854de729fa68da9d5c6b48fa00/setuptools-39.2.0.zip"
    sha256 "f7cddbb5f5c640311eb00eab6e849f7701fa70bf6a183fc8a2c33dd1d1672fb2"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ae/e8/2340d46ecadb1692a1e455f13f75e596d4eab3d11a57446f08259dee8f02/pip-10.0.1.tar.gz"
    sha256 "f2bd08e0cd1b06e10218feaf6fef299f473ba706582eb3bd9d52203fdbd7ee68"
  end

  # https://bugs.launchpad.net/ubuntu/+source/gcc-4.2/+bug/187391
  fails_with :gcc

  def install
    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = "python"
    if build.with?("bootstrap") && MacOS.prefer_64_bit?
      resource("bootstrap").stage buildpath/"bootstrap"
      python = buildpath/"bootstrap/bin/pypy"
    end

    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "/usr/include/tcl", Formula["tcl-tk"].opt_include.to_s
      s.gsub! "'tcl' + _ver, 'tk' + _ver", "'tcl8.6', 'tk8.6'"
    end unless OS.mac?

    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy --targetdir .]
      package_args << "--without-gdbm" if build.without? "gdbm"
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.bz2"
    end

    dylib = OS.mac? ? "dylib" : "so"
    (libexec/"lib").install libexec/"bin/libpypy-c.#{dylib}"
    MachO::Tools.change_install_name("#{libexec}/bin/pypy",
                                     "@rpath/libpypy-c.dylib",
                                     "#{libexec}/lib/libpypy-c.dylib") if OS.mac?

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"lib/libpypy-c.#{dylib}"
  end

  def post_install
    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    unless (libexec/"site-packages").symlink?
      # fix the case where libexec/site-packages/site-packages was installed
      rm_rf libexec/"site-packages/site-packages"
      mv Dir[libexec/"site-packages/*"], prefix_site_packages
      rm_rf libexec/"site-packages"
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils+"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<~EOS
    A "distutils.cfg" has been written to:
      #{distutils}
    specifying the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install_pypy,
    or pip_pypy, any provided scripts will go into the install-scripts folder
    above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
    so you don't overwrite tools from CPython.

    Setuptools and pip have been installed, so you can use easy_install_pypy and
    pip_pypy.
    To update setuptools and pip between pypy releases, run:
        pip_pypy install --upgrade pip setuptools

    See: https://docs.brew.sh/Homebrew-and-Python
  EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/2.7/distutils"
  end

  test do
    system bin/"pypy", "-c", "print('Hello, world!')"
    system bin/"pypy", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end
