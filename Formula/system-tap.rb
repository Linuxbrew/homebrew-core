class SystemTap < Formula
  desc "Infrastructure to simplify the gathering of information of Linux"
  homepage "https://sourceware.org/systemtap/"
  url "https://sourceware.org/systemtap/ftp/releases/systemtap-4.0.tar.gz"
  sha256 "008cc22e8da8f7d16ce3bcc10d36fdd2024b79489c4da3d983e589555ca7c8d5"
  # tag "linuxbrew"

  bottle do
  end

  depends_on "gettext" => :build
  depends_on "elfutils"
  depends_on "python@2"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/stap", "--unprivileged", "-v", "-e", "'probe vfs.read {printf(\"read performed\n\"); exit()}'"
  end
end
