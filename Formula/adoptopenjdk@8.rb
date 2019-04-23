    class AdoptopenjdkAT8 < Formula
      desc "AdoptOpenJDK uses infrastructure, build and test scripts to produce prebuilt binaries from OpenJDK™ class libraries and a choice of either the OpenJDK HotSpot or Eclipse OpenJ9 VM"
      homepage "https://adoptopenjdk.net/"
      url "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03/OpenJDK8U-jdk_x64_linux_hotspot_8u212b03.tar.gz"
      sha256 "dd28d6d2cde2b931caf94ac2422a2ad082ea62f0beee3bf7057317c53093de93"
      depends_on :linux
      option "with-openj9", "Install OpenJ9 instead of HotSpot"
    
      def install
        if build.with? "openj9"
            system "rm -rf *"
            system "wget -O- https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03_openj9-0.14.0/OpenJDK8U-jdk_x64_linux_openj9_8u212b03_openj9-0.14.0.tar.gz | tar --strip-components=1 -zxf -"
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
