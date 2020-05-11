class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.45.6/e2fsprogs-1.45.6.tar.gz"
  sha256 "5f64ac50a2b60b8e67c5b382bb137dec39344017103caffc3a61554424f2d693"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "bf44ad4af62150e9f29827532fced8640fdfcd9ef77e890347ce3eda288be30a" => :catalina
    sha256 "2986dc8e3be65b03e27990226e78ba8bcd2d512381836bb09223f04c94974837" => :mojave
    sha256 "0cdfcb50d1b1046d90d56ece1c4d1c7e624adf4c8b7f19587285bf77b10b7ec7" => :high_sierra
    sha256 "6f5eefda353f129cc71b8b29f9e81b30fad3079aed79ca5e10e8083f25deff3d" => :x86_64_linux
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    # Fix "unknown type name 'loff_t'" issue
    inreplace "lib/ext2fs/imager.c", "loff_t", "off_t"
    inreplace "misc/e2fuzz.c", "loff_t", "off_t"

    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper",
                          "MKDIR_P=mkdir -p",
                          *("--enable-elf-shlibs" unless OS.mac?)
    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
