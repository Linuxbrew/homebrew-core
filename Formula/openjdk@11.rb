class OpenjdkAT11 < Formula
  desc "Java Development Kit"
  homepage "https://jdk.java.net/11/"
  # tag "linuxbrew"

  version "11.0.2"
  if OS.mac?
    url "https://java.com/"
  else
    url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
    sha256 "99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57"
  end

  bottle do

  end

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
