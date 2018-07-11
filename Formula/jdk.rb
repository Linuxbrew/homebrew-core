class Jdk < Formula
  desc "Java Platform, Standard Edition Development Kit (JDK)"
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
  # tag "linuxbrew"

  version "9.0.4"
  version_scheme 1
  if OS.linux?
    url "http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-9.0.4_linux-x64_bin.tar.gz"
    sha256 "90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2"
  elsif OS.mac?
    url "http://java.com/"
  end

  bottle do
    cellar :any_skip_relocation
  end

  def install
    odie "Use 'brew cask install java' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
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
