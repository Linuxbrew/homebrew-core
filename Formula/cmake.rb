class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz"
  sha256 "aecf6ecb975179eb3bb6a4a50cae192d41e92b9372b02300f9e8f1d5f559544e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd249c48979cc3df65cc7b1a0cc00a1d702bdf0e95ac616cee16c9daea576c59"
    sha256 cellar: :any_skip_relocation, big_sur:       "44f432c44eef7f20474002009392ab763be05c1962a086b7c79cb9f9bf4df47c"
    sha256 cellar: :any_skip_relocation, catalina:      "abf670453c8e7394215bbad68cf11e1bae8e598a86cc7886f4d3a9f48e9ef87a"
    sha256 cellar: :any_skip_relocation, mojave:        "a60610090a757e36e9799be128d8404330ebd79e6d1e19fe3926dbcb95fd8e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36c8ac4c985a32d1507ade71ae6eb3aa04e0ca8be65b9312f361973fd76a00c4"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    on_linux do
      ENV.cxx11
    end

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
