class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.8.tar.gz"
  sha256 "43e644f408acf354e1a0fd963d00c06eb7f6371787b2dfd20c04a3caa576ac34"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "064b4a730a88e33eba7901c01164cf7004cd97480a6582ad30d0efef614c644a"
    sha256 big_sur:       "9dae43467ed6999baea57bd290511bce0e23772e7fc46daea074c8edfb0ffe8b"
    sha256 catalina:      "9f664e09621817471822de2d244c95122fc51af85d12b71c56cab3739dd0d988"
    sha256 mojave:        "c8b8aed256b2b4b22001af7c41cf7008c6cf5d30e5826ffb84604387f888c525"
    sha256 x86_64_linux:  "5cb6b0db3db8b43921366923e186503601e61ef41391d6e46c6dd34903088787"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
