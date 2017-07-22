class JdkDownloadStrategy < CurlDownloadStrategy
  def _curl_opts
    super << "--cookie" << "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  desc "Java Platform, Standard Edition Development Kit (JDK)."
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
  # tag "linuxbrew"

  version "1.8.0-141"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha256 "041d5218fbea6cd7e81c8c15e51d0d32911573af2ed69e066787a8dc8a39ba4f"
  elsif OS.mac?
    url "http://java.com/"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "87f69d17dd3e0ae0a5b39e60465e88a4602bd692ef5c647f220af3d47779dba6" => :x86_64_linux
  end

  def install
    odie "Use 'brew cask install java' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    By installing and using JDK you agree to the
    Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
    http://www.oracle.com/technetwork/java/javase/terms/license/index.html
    EOS
  end

  test do
    (testpath/"Hello.java").write <<-EOS.undent
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
