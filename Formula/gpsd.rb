class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.21.tar.xz"
  mirror "https://download-mirror.savannah.gnu.org/releases/gpsd/gpsd-3.21.tar.xz"
  sha256 "5512a7d3c2e86be83c5555652e5b4cc9049e8878a4320be7f039eb1a7203e5f0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/gpsd/"
    regex(/href=.*?gpsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "94c0f86ec9ec850c0fd8f8b3069e6881dd895e57324c5eb46822406441208317"
    sha256 cellar: :any, big_sur:       "a68031d9cbef4b9cfbdfed566b8d0e556ae8188cedd6f505ca65314588bbc7f4"
    sha256 cellar: :any, catalina:      "e41f44df2cf96b33b2f62e65ff2ef9154d872bc8fac88b3bdaeb503246d77c2b"
    sha256 cellar: :any, mojave:        "caafc4aea3632fdbe8df1ce265c025430a816d2ad7c26f973c254887ec6a2a8f"
    sha256 cellar: :any, high_sierra:   "bc0775e450c0129fd71a4abd163a7645ac9b3e1698009b2735fafeb838e09e79"
    sha256 cellar: :any, x86_64_linux:  "887f7fdc77d9e7826dfdb2bf2b8ad919dc6b15da71c6fe2f3ff74489d6c072ed" # linuxbrew-core
  end

  depends_on "scons" => :build

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    system "scons", "install"
  end

  def caveats
    <<~EOS
      gpsd does not automatically detect GPS device addresses. Once started, you
      need to force it to connect to your GPS:

        GPSD_SOCKET="#{var}/gpsd.sock" #{sbin}/gpsdctl add /dev/tty.usbserial-XYZ
    EOS
  end

  service do
    run [opt_sbin/"gpsd", "-N", "-F", var/"gpsd.sock"]
    keep_alive true
    error_log_path var/"log/gpsd.log"
    log_path var/"log/gpsd.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/gpsd -V")
  end
end
