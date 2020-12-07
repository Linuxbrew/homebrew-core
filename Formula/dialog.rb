class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20201126.tgz"
  sha256 "c9233a6c8ea33a59e2378e5146ae2bd13b519744cfdb647af7420adac5ad3866"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eb3455238be98e27905b275e88723a0e0ccee0c959ca1124ba681728626e08b6" => :big_sur
    sha256 "6424be28f3960234be513799a2161d1c0d8dc46c5be3e3581fab50f0329e3f96" => :arm64_big_sur
    sha256 "6fc24c87e6cf32e7702c0f9e64eba5ad79908b84bf1614cc62a99c967bb659ea" => :catalina
    sha256 "0bb780acdabb6d05e8e6465fa8f204758a27c39caf7fc93fa9e5da17dcfeac31" => :mojave
    sha256 "747365a32e09bcae7384af7b565244238965e0712d914e70453ef4ca90951b6f" => :x86_64_linux
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
