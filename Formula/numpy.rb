class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/66/03/818876390c7ff4484d5a05398a618cfdaf0a2b9abb3a7c7ccd59fe181008/numpy-1.21.0.zip"
  sha256 "e80fe25cba41c124d04c662f33f6364909b985f2eb5998aaa5ae4b9587242cce"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "88df8a9ea03e217ed2d648eaacd541003f15437bbe9a575ed3b4c0c8a123efd0"
    sha256 cellar: :any, big_sur:       "303ca5f3bfe16812f0f2fead2b29230906752032d45014a6e972a698ff8922f4"
    sha256 cellar: :any, catalina:      "66b7372569ec253cb81ab172903dbed96495cbca2452d41119867161bfd4433a"
    sha256 cellar: :any, mojave:        "f34cc0cd3046377a5640147f4adc26be75dcfc36dbeee92dc71147cc9e85c5f9"
    sha256               x86_64_linux:  "a289a636ab56b69f3672f2fd9758c531a7ac71b01abe0befc4ee42d99ee42516" # linuxbrew-core
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  fails_with gcc: "5"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
        "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
