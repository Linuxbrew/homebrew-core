class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.3.1.tar.gz"
  sha256 "f95cbbba27f427bc3da41e9296e632c4bba1c47d107a9c911e82a524c136c406"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "fb6a2b27a04b3c58eb9cc9f3c11966c6497190f8500a574610d48b1df8884416"
    sha256 big_sur:       "52563870e763b9012aa676db4751232ecbfeee0c3b3d57c7ac4f968fca7114b4"
    sha256 catalina:      "8e96a5811ccc5fd5898459442a7c70b9c143246374bb1801d472ecf779a23123"
    sha256 mojave:        "f7f4295250789184496dde21eda27a2145e3df37629f9a90ffe93d69f901044a"
    sha256 x86_64_linux:  "87adc2f06c9e3d9daf1d7e36446943c88ce94fb2dbbb0eb432a60f4cb3ccabcc" # linuxbrew-core
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
