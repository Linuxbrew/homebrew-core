class JdkDownloadStrategy < CurlDownloadStrategy
  def _curl_opts
    super << "--cookie" << "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  desc "Java™ Platform, Standard Edition Development Kit (JDK™)."
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
  # tag "linuxbrew"

  version "1.8.0-131"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha256 "62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236"
  elsif OS.mac?
    url "http://java.com/"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6c98492fd5e0c8195b2e573245cce13942ee31fcb8b811a1d27509662759ef2c" => :x86_64_linux
  end

  def install
    odie "Use 'brew cask install java' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
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
