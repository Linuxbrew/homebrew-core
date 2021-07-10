class Lib3ds < Formula
  desc "Library for managing 3D-Studio Release 3 and 4 '.3DS' files"
  homepage "https://code.google.com/archive/p/lib3ds/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/lib3ds/lib3ds-1.3.0.zip"
  sha256 "f5b00c302955a67fa5fb1f2d3f2583767cdc61fdbc6fd843c0c7c9d95c5629e3"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "2959476e3f2e5a95ca23aa6a9fc4b11f9e8ca202e460d6b00ce2906f043c8936"
    sha256 cellar: :any, big_sur:       "175e42127a596271ed3347b35eeb8088d684b1b46f6efa4d1bbb8d8ef9776605"
    sha256 cellar: :any, catalina:      "0a5a1fdac0c459e011ef64556c872fdc61678ccc7e06d507239d03729a0a8613"
    sha256 cellar: :any, mojave:        "61004e5169608ab48287024f45c10f9f95eebd3117edce42cf3a3bf509b93166"
    sha256 cellar: :any, high_sierra:   "1c6d7e3a2e800cf8fc9f6050032f28eec15bcc7c617622d58ba502c9c1afa740"
    sha256 cellar: :any, sierra:        "4338a4f81ccc33ad78b30f051085594606b74fe5f7773e197a36f08e0b8967ba"
    sha256 cellar: :any, el_capitan:    "e5810afd47dd88fb769e6ef62ef558b4ee4e643d4f5ae3fddb019257642b3375"
    sha256 cellar: :any, yosemite:      "33f5b51953a8d4a583c7d5d6a7796ffaaccf8bf6a303fac300bfdb76dcd0ad60"
    sha256 cellar: :any, x86_64_linux:  "3fc16bc23ab20951e579914bc8d3f3ad97c88cd6f204591370cd887be3bfc2c6" # linuxbrew-core
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # create a raw emtpy 3ds file.
    (testpath/"test.3ds").write("\x4d\x4d\x06\x00\x00\x00")
    system bin/"3dsdump", "test.3ds"
  end
end
