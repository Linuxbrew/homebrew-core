class DeviceMapper < Formula
  desc "Device mapper userspace library and tools"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
    :tag      => "v2_02_186",
    :revision => "4e5761487efcb33a47f8913f5302e36307604832"
  version "2.02.186"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9a0ecca9c06b7f9ac4483406452aa241f1429667a1ee41948426b8a5347eb74" => :x86_64_linux
  end

  depends_on "libaio"
  depends_on :linux

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
end
