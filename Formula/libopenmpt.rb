class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.10+release.autotools.tar.gz"
  version "0.5.10"
  sha256 "59a8fa28d8b8df69cb7fa5972bdf931081dab4e1e1156c69a1a53b65c2be9ffa"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "75145d9635ac938c7ba553d3f51f66f44cf0c0aeff681fdc06472bd7cee708a9"
    sha256 cellar: :any,                 big_sur:       "a3f50c4544b5fe6b7494ed6a10dc73d95fe60b8d2148ac8de16e1acf1fcf886a"
    sha256 cellar: :any,                 catalina:      "982ab967c30a8c3090f85cc7fa0a4978ce6db9d52c3590e88fd6aefb27cb006b"
    sha256 cellar: :any,                 mojave:        "cec457bc736a126acf909c3a25283c6e0643018e548366b1e127c0517f349f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaedf845e781ef6b93950e35dd04f12ca85de63f01c48683c28b13da1d17fa4c" # linuxbrew-core
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
