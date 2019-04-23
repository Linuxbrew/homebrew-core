    class AdoptopenjdkAT11 < Formula
      desc "AdoptOpenJDK are prebuilt binaries of OpenJDK"
      homepage "https://adoptopenjdk.net/"
      url "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.3_7.tar.gz"
      sha256 "23cded2b43261016f0f246c85c8948d4a9b7f2d44988f75dad69723a7a526094"
      option "with-openj9", "Install OpenJ9 instead of HotSpot"
      depends_on :linux
    
      def install
        if build.with? "openj9"
            system "rm -rf *"
            system "wget -O- https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7_openj9-0.14.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.3_7_openj9-0.14.0.tar.gz | tar --strip-components=1 -zxf -"
        end
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
        assert_equal "Hello Homebrew
", shell_output("#{bin}/java Hello")
      end
    end
