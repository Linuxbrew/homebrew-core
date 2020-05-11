class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.1.2/turnserver-4.5.1.2.tar.gz"
  sha256 "5f34ded2c2871c74d498712c3fbfce8a418f8ea8e6508adc07cfe5e152881455"

  bottle do
    sha256 "49feaa7d1896622d9716abd64dd4e70b7719671ab0e6f69be4fe50b607b4b135" => :catalina
    sha256 "e879670cd71f12e49d5ad656242f08aa076d1c0e84022def767637e4c7cd770f" => :mojave
    sha256 "5cb6a86a0beca4eb08b8d660095db3d146f66a904b54b7d5de00e6c55f1d1652" => :high_sierra
    sha256 "92940d68b1d500336dd33a10db6dced0265c64caceae5873a66d795e53a15a6b" => :x86_64_linux
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
