class OpenjdkAT11 < Formula
  desc "Java Development Kit"
  homepage "https://jdk.java.net/11/"
  # tag "linuxbrew"

  version "11+28"
  if OS.mac?
    url "https://java.com/"
  else
    url "https://download.java.net/java/early_access/jdk11/28/GPL/openjdk-11+28_linux-x64_bin.tar.gz"
    sha256 "3784cfc4670f0d4c5482604c7c513beb1a92b005f569df9bf100e8bef6610f2e"
  end

  bottle :unneeded

  depends_on :linux

  def install
    prefix.install Dir["*"]
    share.mkdir
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
