class DeviceMapper < Formula
  desc "Device mapper userspace library and tools"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
    :tag      => "v2_02_186",
    :revision => "4e5761487efcb33a47f8913f5302e36307604832"
  version "2.02.186"
  # tag "linuxbrew"

  bottle do
  end

  depends_on "libaio"

  def install
    # https://github.com/NixOS/nixpkgs/pull/52597
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-pkgconfig"
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end

  test do
    # TODO
  end
end
