class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.04.14.105.tar.gz"
  sha256 "27db6a31e62c6ce03b2ccc846cbc572c84f85b1dc32f5d440b41f3d148f57d56"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "8bea033ec6dcb9e3603257ce16ffaef8066644982560e6220f738fffc5262c78" => :catalina
    sha256 "2f08d7c08d97e4ba6a557afd05169ee53696111a1eb3538c8d69341c4e018e3e" => :mojave
    sha256 "693014dbfaf314819a78040833fc9fd8fff680fa25dcc0223a31b12cf56fbd6b" => :high_sierra
    sha256 "6e1b8d9784f1c5f17b18bf2899894eda46903dc52e00cb98e2d97e1d2f6e075d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
