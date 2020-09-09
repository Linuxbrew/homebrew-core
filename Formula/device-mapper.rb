class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
    tag:      "v2_03_10",
    revision: "4d9f0606beb0acb329794909560433c08b50875d"

  livecheck do
    url :stable
    strategy :page_match
    regex(/href=.*?;a=tag;.*?>Release (\d+(?:\.\d+)+)</i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "152056e9f33c4d22f82a84c85d21a920d9f9a645be10f67644b8830a05fcff7e" => :x86_64_linux
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
