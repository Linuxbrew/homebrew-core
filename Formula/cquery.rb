class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180302",
                                                      :revision => "f3e9e756e182b122bef8826a77047f6ccf5529b6"
  head "https://github.com/cquery-project/cquery.git"

  unless OS.mac?
    resource "ncurses" do
      url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
      sha256 "aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17"
    end

    depends_on "gpatch" => :build
    depends_on "patchelf" => :build
    depends_on "python@2" => :build
    depends_on "rsync" => :build
    depends_on "xz" => :build
    depends_on "zlib"

    needs :cxx11
  end

  bottle do
    cellar :any
    sha256 "0f567e5d88299f28d489b666fca2cf320b91062fc053e0c2a8a1ad9e1bc76598" => :high_sierra
    sha256 "06bb25b1c91c76c894d3aebdc18b76591ab2ff1c5f8190c376b69e60d6c22787" => :sierra
    sha256 "9692d28682c009a9bec583ff20aa16ce5c790975375755a5a48a28ec3e3953c4" => :el_capitan
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["JOBS"] = "8" if ENV["CIRCLECI"]

    unless OS.mac?
      # the vendored libclang.so requires libtinfo.so.5
      resource("ncurses").stage do
        system "./configure", "--disable-pc-files",
                              "--with-shared",
                              "--enable-sigwinch",
                              "--enable-widec",
                              "--with-gpm=no",
                              "--without-ada",
                              "--without-normal",
                              "--without-debug",
                              "--with-abi-version=5"
        system "make"
        (libexec/"ncurses/lib").install "lib/libncursesw.so.5.9" => "libtinfo.so.5"
        ENV["LDFLAGS"] = "-Wl,-rpath=#{libexec}/ncurses/lib"
      end
    end

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    unless OS.mac?
      # fix rpath for the vendored libclang.so
      system "patchelf", "--force-rpath",
                         "--set-rpath", "#{libexec}/ncurses/lib:#{HOMEBREW_PREFIX}/lib",
                         *Dir["#{lib}/**/libclang.so.*"]
    end
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
