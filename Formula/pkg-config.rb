class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/pkg-config-0.29.2.tar.gz"
  sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"

  bottle do
    sha256 "8eb723bfc03cd468d779d54d015d47d2e8ab1dd4d35e595ab4abaca8833b3277" => :sierra
    sha256 "93f044f166bcbd84db14133ee4f56104031c65409cfd2801c7ac0d182936dc78" => :el_capitan
    sha256 "d9ccc19f1a55919408a1b27260b0404aa36dc6782a4a5964e6fd8409abf3b830" => :yosemite
    sha256 "5ed3c456955fc6aae4658fc3165004dce567a5826dcd4df42011c8c95f159652" => :x86_64_linux
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    if OS.mac?
      pc_path += %W[/usr/local/lib/pkgconfig /usr/lib/pkgconfig #{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"]
    else
      pc_path << "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path.join(File::PATH_SEPARATOR)}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pkg-config", "--libs", "libpcre"
  end
end
