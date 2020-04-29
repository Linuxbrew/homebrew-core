class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.6.2/datetime-fortran-1.6.2.tar.gz"
  sha256 "765f4ea77e9057f099612f66e52f92162f9f6325a8d219e67cb9d5ebaa41b67e"

  bottle do
    cellar :any_skip_relocation
    sha256 "73f230fd02a4dcc810e5dff0b6c91fd652d71d205aabad40b781fb5cc4b85ce3" => :catalina
    sha256 "53b0711bb7bae0a6ceab81d1c81475ab7d9b4a3faf9293ef5ef425d9f008cd51" => :mojave
    sha256 "4da37b7d4a520168a526cc63ed413c1bea31f769b02a7a471de1cf854623a379" => :high_sierra
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    if OS.mac?
      system "gfortran", "-o", "test", "-I#{include}", "-L#{lib}", "-ldatetime",
                         pkgshare/"test/datetime_tests.f90"
    else
      system "gfortran", "-I#{include}", pkgshare/"test/datetime_tests.f90",
                         "-L#{lib}", "-ldatetime", "-o", "test"
    end
    system "./test"
  end
end
