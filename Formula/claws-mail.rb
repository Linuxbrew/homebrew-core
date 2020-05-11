class ClawsMail < Formula
  desc "The user-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.5.tar.gz"
  sha256 "f79e4c7f089d08e6b2b3323a90b6f46991a154ce168ba4a829d593b7a5768c7b"

  bottle do
    sha256 "21715bb6c0a1311197209fc443741d7c75051dc83a7f03ed18a876cd8df95e94" => :catalina
    sha256 "c45802e7cd2c2d09c41a08e44ebaa9ebc7b8209a41a4e7c7308dde6fc960bfc6" => :mojave
    sha256 "0ae3a6b02360f9a4dfefbdc5e5e0325230436992ce16ba669c99ca6928ab5557" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "LDFLAGS=-Wl,-framework -Wl,Security",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
