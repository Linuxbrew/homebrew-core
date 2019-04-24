class AdoptopenjdkAT8 < Formula
  desc "AdoptOpenJDK are prebuilt binaries of OpenJDK"
  homepage "https://adoptopenjdk.net/"
  if build.with? "openj9"
    url "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03_openj9-0.14.0/OpenJDK8U-jdk_x64_linux_openj9_8u212b03_openj9-0.14.0.tar.gz"
    sha256 "56f9bdbb3962a5f149ce2e4946f7bd7d12c3b70a1d7df91bbd46fe55f9553421"
  else
    url "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03/OpenJDK8U-jdk_x64_linux_hotspot_8u212b03.tar.gz"
    sha256 "dd28d6d2cde2b931caf94ac2422a2ad082ea62f0beee3bf7057317c53093de93"
  end
  option "with-openj9", "Install OpenJ9 instead of HotSpot"
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
