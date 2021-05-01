class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.8+release.autotools.tar.gz"
  version "0.5.8"
  sha256 "29e2c21174b73f67f2ba5ee76808d62f182b130e4f704ee2d9ae8283982d8acd"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec9c20d421d0d34f93b3af226f8c4ce08e6b5abe9a0a4da0df41a6d5b6372621"
    sha256 cellar: :any,                 big_sur:       "614afdfa4fde0392b079a2227fb2b9b5e71e7eb0a1ef320293fe63222e2bedce"
    sha256 cellar: :any,                 catalina:      "a524d3978873fa0f9e056b9e464673e4f72f04b106a70960400c606ac0d13c03"
    sha256 cellar: :any,                 mojave:        "a41313785afa2e9334d07dee8a7c3e33391dadaf2e89234140f8498a193b32cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345224c92a4dcca8de7f9cea0e72a940b137dea2cc1d26bd8eedf0a8e25b13aa"
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
