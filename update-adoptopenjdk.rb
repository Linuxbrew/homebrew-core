require "digest/sha2"
[8, 11].each do |version|
    hotspot_url = `wget -O- https://api.github.com/repos/AdoptOpenJDK/openjdk#{version}-binaries/releases | jq -j 'map(select(.prerelease|not))|map(.assets)|flatten|map(select(.name|test("jdk.*x64_linux.*hotspot")))|.[0].browser_download_url'`
    openj9_url = `wget -O- https://api.github.com/repos/AdoptOpenJDK/openjdk#{version}-binaries/releases | jq -j 'map(select(.prerelease|not))|map(.assets)|flatten|map(select(.name|test("jdk.*x64_linux.*openj9")))|.[0].browser_download_url'`
    system "wget -nc -O hotspot@#{version} #{hotspot_url}"
    system "wget -nc -O openj9@#{version} #{openj9_url}"
    hotspot_sha256 = Digest::SHA256.file("hotspot@#{version}").to_s
    openj9_sha256 = Digest::SHA256.file("openj9@#{version}").to_s
    File.write("Formula/adoptopenjdk@#{version}.rb", <<-FORMULA)
    class AdoptopenjdkAT#{version} < Formula
      desc "AdoptOpenJDK are prebuilt binaries of OpenJDK"
      homepage "https://adoptopenjdk.net/"
      url "#{hotspot_url}"
      sha256 "#{hotspot_sha256}"
      option "with-openj9", "Install OpenJ9 instead of HotSpot"
      depends_on :linux
    
      def install
        if build.with? "openj9"
            system "rm -rf *"
            system "wget -O- #{openj9_url} | tar --strip-components=1 -zxf -"
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
        assert_equal "Hello Homebrew\n", shell_output("\#{bin}/java Hello")
      end
    end
    FORMULA
end
