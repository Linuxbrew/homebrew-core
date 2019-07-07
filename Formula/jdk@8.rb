class JdkAT8 < Formula
  desc "Java Platform, Standard Edition Development Kit (JDK)"
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
  # tag "linuxbrew"

  version "1.8.0-181"
  if OS.mac?
    url "http://java.com/"
  else
    url "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz",
      :cookies => {
        "oraclelicense" => "accept-securebackup-cookie",
      }
    sha256 "1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3"
  end

  bottle :unneeded

  keg_only :versioned_formula

  def install
    odie "Use 'brew cask install java' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
    share.mkdir
    share.install prefix/"man"
  end

  def caveats; <<~EOS
    By installing and using JDK you agree to the
    Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
    http://www.oracle.com/technetwork/java/javase/terms/license/index.html
  EOS
  end

  test do
    (testpath/"Hello.java").write <<~EOS
      class Hello
      {
        public static void main(String[] args)
        {
          System.out.println("Hello Homebrew");
        }
      }
    EOS
    system bin/"javac", "Hello.java"
    assert_predicate testpath/"Hello.class", :exist?, "Failed to compile Java program!"
    assert_equal "Hello Homebrew\n", shell_output("#{bin}/java Hello")
  end
end
