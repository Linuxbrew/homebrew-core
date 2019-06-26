class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.3.tar.gz"
  sha256 "b248c91d65c7a101b9d6226025f2b4bf3dabe94c0c49ab6d51ce84a22a39622b"
  revision 1
  head "https://github.com/ledger/ledger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "475f900dc75447cd051934b33eba933ffa4ad9a8d095600d3e39b3bbea0995eb" => :mojave
    sha256 "3f57545bdc6d73ec191f5f6cb34f9dd362b40f7c3217e15f3cb21149438745a6" => :high_sierra
    sha256 "5aa613f6b42bc0f158564b63691783664d3f3de6e7fdf44e06e1848879b7f4d1" => :sierra
    sha256 "350d2d37bbaab8b68ff1379cd82224198038d59febb48fea7541798105d1978b" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"
  uses_from_macos "groff"

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j1" if ENV["CIRCLECI"]

    ENV.cxx11

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --python
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DUSE_PYTHON27_COMPONENT=1
    ]
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py"
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

    system "python", pkgshare/"demo.py"
  end
end
