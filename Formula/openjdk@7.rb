class OpenjdkAT7 < Formula
  desc "Java Development Kit"
  homepage "http://jdk.java.net/archive/"
  # tag "linuxbrew"

  version "1.7.0-75"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://download.java.net/openjdk/jdk7u75/ri/openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz"
    sha256 "56d84d0bfc8c1194d501c889765a387e949d6a063feef6608e5e12b8152411fb"
  end

  bottle :unneeded

  depends_on :linux

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
    share.mkdir
    share.install prefix/"man"
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
