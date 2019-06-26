class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://squashfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"
  revision 2

  bottle do
    cellar :any
    sha256 "c48d6bf745747564c7b8736c1f703165d0787415d54c09680e272e2d68fdd572" => :mojave
    sha256 "59fe238379463c52b0e219192139180be496fcc20adc734a84699f34191461c3" => :high_sierra
    sha256 "2e015389c160a1094f0995e3d5b11f54b0549cbab7a506cbb2706608213735a6" => :sierra
    sha256 "4d452939eed445ee41d397aa1dae6ae20d08316fdd845c1b777acb3225304ec8" => :x86_64_linux
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  uses_from_macos "zlib"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/05ae0eb1/squashfs/squashfs-osx-bundle.diff"
    sha256 "276763d01ec675793ddb0ae293fbe82cbf96235ade0258d767b6a225a84bc75f"
  end

  # Fixes the following compilation issue of squash4.3 with newer versions of gcc:
  # "mksquashfs.c:987:24: error: called object 'major' is not a function or function pointer"
  patch do
    url "https://raw.githubusercontent.com/rchikhi/formula-patches/14e9deef14117908e24c17b81b60b11996688991/squashfs/squashfs-new-gcc.diff"
    sha256 "24e51ef16f6e6101b59f4913aa4acbd6ff541a1953e923019e8648f6e6bdd582"
  end

  def install
    args = %W[
      EXTRA_CFLAGS=-std=gnu89
      LZ4_SUPPORT=1
      LZMA_XZ_SUPPORT=1
      LZO_DIR=#{Formula["lzo"].opt_prefix}
      LZO_SUPPORT=1
      XATTR_SUPPORT=0
      XZ_DIR=#{Formula["xz"].opt_prefix}
      XZ_SUPPORT=1
    ]

    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end
    doc.install %w[ACKNOWLEDGEMENTS INSTALL OLD-READMEs PERFORMANCE.README README-4.3]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unsquashfs -v", 1)
  end
end
