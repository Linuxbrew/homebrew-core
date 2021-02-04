class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-protocols-1.20.tar.xz"
  sha256 "9782b7a1a863d82d7c92478497d13c758f52e7da4f197aa16443f73de77e4de7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64e9fc4ff59725f13c60644b9157d099d283eaedc35a451f2b5d6814a3cc9b3c"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "wayland" => :build
  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
