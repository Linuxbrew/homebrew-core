class JdkAT8 < Formula
  desc "Java Platform, Standard Edition Development Kit (JDK)"
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
  # tag "linuxbrew"

  version "1.8.0-212"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://download.oracle.com/otn/java/jdk/8u212-b10/59066701cf1a433da9770636fbc4c9aa/jdk-8u212-linux-x64.tar.gz",
      :cookies => {
        "oraclelicense" => "accept-securebackup-cookie",
      }
    sha256 "3160c50aa8d8e081c8c7fe0f859ea452922eca5d2ae8f8ef22011ae87e6fedfb"
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
