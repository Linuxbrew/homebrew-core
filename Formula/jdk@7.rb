class JdkAT7 < Formula
  desc "Java Platform, Standard Edition Development Kit (JDK)"
  homepage "https://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html"

  version "1.7.0-80"
  if OS.linux?
    url "https://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz"
    sha256 "bad9a731639655118740bee119139c1ed019737ec802a630dd7ad7aab4309623"
  elsif OS.mac?
    url "https://java.com/"
  end

  bottle :unneeded

  keg_only :versioned_formula

  depends_on :linux

  def install
    odie "Use 'brew cask install Caskroom/versions/java7' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
    share.mkdir
    share.install prefix/"man"
  end

  def caveats
    <<~EOS
      By installing and using JDK you agree to the
        Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
        http://www.oracle.com/technetwork/java/javase/terms/license/index.html
    EOS
  end

  test do
    system "#{bin}/java", "-version"
    system "#{bin}/javac", "-version"
  end
end
