class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz"
  sha256 "3d569869d27b48860210c758c4f313082103a5e58219a7669b52bfd29d674780"

  bottle do
    cellar :any
    sha256 "3c620068fba4bf15b6138ffc4042ab2111a67201310523104c07c314115520bb" => :sierra
    sha256 "a2d2bf8be8ffb614f0490801e38558681b8b01a9fc7ff4be5f785d3db7f71157" => :el_capitan
    sha256 "8078fbe4b7fd092a197c452af4caf3f5eaeb27dce16afd46e1da2a1ec1ae7f6d" => :yosemite
    sha256 "a584ac685ac8262083d4522780d26761feb0896670d7384fb064f2b262360508" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
