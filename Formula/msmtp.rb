class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.10.tar.xz"
  sha256 "caba7f39d19df7a31782fe7336dd640c61ea33b92f987bd5423bca9683482f10"

  bottle do
    sha256 "ae5634512b5c69936c1755b182d8eafccca28005d28f4f7d8b41d074f64da66f" => :catalina
    sha256 "813d8e19745ad1642d69203d1d977ab124bf32e612220834a04ddd5086219308" => :mojave
    sha256 "d1d3b8b75826e109a521575b4b09d6690d34f73f488b8cca1c34f4c33c97b582" => :high_sierra
    sha256 "58b070a876d6df531e86382b8be061fb8e9275f763e02346aa24fdb5b6f23dc4" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libsecret" unless OS.mac?

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
