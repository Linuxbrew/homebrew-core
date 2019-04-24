class AdoptopenjdkAT11 < Formula
  desc "AdoptOpenJDK are prebuilt binaries of OpenJDK"
  homepage "https://adoptopenjdk.net/"
  if build.with? "openj9"
    url "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7_openj9-0.14.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.3_7_openj9-0.14.0.tar.gz"
    sha256 "8ed83ebed830539c93545b8095d08a5bd48946ab1bdc523e39320417a4d59909"
  else
    url "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.3_7.tar.gz"
    sha256 "39dad3e7d94fd8d313d24563677316cb72c0490af50de4f852bc5217e58c098e"
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
