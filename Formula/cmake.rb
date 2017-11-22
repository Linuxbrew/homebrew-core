class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz"
  sha256 "b3345c17609ea0f039960ef470aa099de9942135990930a57c14575aae884987"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f789d5e9d3ca2c2fef5a3587c824b991fd57ea14a30f4722a93ffcd2610bded" => :high_sierra
    sha256 "886c3b67d73d101308c2bfa3a63e00d31a37e6e3682311b65b8bd76e04b03c8e" => :sierra
    sha256 "d1752e5789c7e91ee368cdf40a138b6fad8eea267e779917aae2b5e788121f5a" => :el_capitan
    sha256 "67d08963141a3a14f606fbb977f40f5380fa30d4e96b024720b31f35b0161ad8" => :x86_64_linux
  end

  devel do
    url "https://cmake.org/files/v3.10/cmake-3.10.0-rc5.tar.gz"
    sha256 "7c4322f778d0ac67413de0a3217c1638675d4fceab6564c9b448d617d41aedf6"
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "curl"
    depends_on "libidn" => :optional
    depends_on "ncurses"
  end

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV.deparallelize if ENV["CIRCLECI"]

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    if build.with? "docs"
      # There is an existing issue around macOS & Python locale setting
      # See https://bugs.python.org/issue18378#msg215215 for explanation
      ENV["LC_ALL"] = "en_US.UTF-8"
      args << "--sphinx-man" << "--sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    if build.with? "completion"
      cd "Auxiliary/bash-completion/" do
        bash_completion.install "ctest", "cmake", "cpack"
      end
    end

    elisp.install "Auxiliary/cmake-mode.el"
  end

  def post_install
    inreplace "#{pkgshare}/Modules/Platform/UnixPaths.cmake" do |s|
      s.gsub! "list(APPEND CMAKE_SYSTEM_INCLUDE_PATH", "list(APPEND CMAKE_SYSTEM_INCLUDE_PATH\n  #{HOMEBREW_PREFIX}/include"
      s.gsub! "list(APPEND CMAKE_SYSTEM_LIBRARY_PATH", "list(APPEND CMAKE_SYSTEM_LIBRARY_PATH\n  #{HOMEBREW_PREFIX}/lib"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
