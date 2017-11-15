# bchunk: Build a bottle for Linuxbrew
class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.2.tar.gz"
  sha256 "e7d99b5b60ff0b94c540379f6396a670210400124544fb1af985dd3551eabd89"
  head "https://github.com/hessu/bchunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6183607b5b987345ee3380263819f1d5e12f2f3cc9f6fd55accfbf92c26d5ef" => :high_sierra
    sha256 "95ef5fddc2234902187dde834690fb5957bd99ce11403e3d0f8881a705bb8f27" => :sierra
    sha256 "665af973709071e982939f37ba39c79c6e41f7f18277d65670475ba9d8315f94" => :el_capitan
  end

  # Last upstream release was in 2004, so probably safe to assume this isn't
  # going away any time soon.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    sha256 "8c7b530e37f0ebcce673c74962214da02aff7bb1ecc96a4dd359e6115f5c0f57"
    apply "patches/01-track-size.patch",
          "patches/CVE-2017-15953.patch",
          "patches/CVE-2017-15955.patch"
  end

  def install
    system "make"
    bin.install "bchunk"
    man1.install "bchunk.1"
  end

  test do
    (testpath/"foo.cue").write <<~EOS
      foo.bin BINARY
      TRACK 01 MODE1/2352
      INDEX 01 00:00:00
    EOS

    touch testpath/"foo.bin"

    system "#{bin}/bchunk", "foo.bin", "foo.cue", "foo"
    assert_predicate testpath/"foo01.iso", :exist?
  end
end
