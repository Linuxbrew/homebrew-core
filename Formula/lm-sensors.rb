class LmSensors < Formula
  desc "Tools for monitoring the temperatures, voltages, and fans"
  homepage "https://github.com/groeck/lm-sensors"
  url "https://github.com/lm-sensors/lm-sensors/archive/V3-5-0.tar.gz"
  version "3.5.0"
  sha256 "f671c1d63a4cd8581b3a4a775fd7864a740b15ad046fe92038bcff5c5134d7e0"
  # tag "linux"

  bottle do
    sha256 "ac30eb43d5fc1691278882d6924bd20b00f1e66df6342601f30dfe926e94f00c" => :x86_64_linux
  end

  depends_on "bison" => :build
  depends_on "flex" => :build

  def install
    args = %W[
      PREFIX=#{prefix}
      BUILD_STATIC_LIB=0
      MANDIR=#{man}
      ETCDIR=#{prefix}/etc
    ]
    system "make", *args
    system "make", *args, "install"
  end

  test do
    assert_match("Usage", shell_output("#{bin}/sensors --help"))
  end
end
