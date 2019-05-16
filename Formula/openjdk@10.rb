class OpenjdkAT10 < Formula
  desc "Java Development Kit"
  homepage "http://jdk.java.net/10/"
  bottle do
    sha256 "07db75aecdfd58b5fb0b7eca8885de56a42134b07ed4c05764967569583c63d7" => :x86_64_linux
  end

  # tag "linuxbrew"

  version "10.0.2"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
    sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
  end

  bottle :unneeded

  depends_on :linux

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
