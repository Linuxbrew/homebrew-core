class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.2.0.tar.gz"
  sha256 "9a2f1886be0181bfa0a8b3ea05207d5c6e55497d7f821af3d7e60a8e53ba11d0"
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "4bd47ae0dcd23404afacbc04e92b77f03607033be22a34aebf1b67de2636d265" => :catalina
    sha256 "249d16b3bc85f8d2cfe441c492bef7d43e36455aa019e844102b2471ae5f1931" => :mojave
    sha256 "295ed70b26b8134cc9df662f2ab03531c849067a97852fb4891f4ee662a87c2c" => :high_sierra
    sha256 "de60186763b752f3362d34bac20a22087378fe7c713e647f83c245bc4f54b823" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.8"

  uses_from_macos "groff"

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
    ] + std_cmake_args
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
