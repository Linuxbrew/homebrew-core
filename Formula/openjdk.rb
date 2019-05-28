class Openjdk < Formula
  # tag "linuxbrew"
  desc "Java Development Kit"
  homepage "https://github.com/ojdkbuild/"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u212-b04/jdk-8u212-ojdkbuild-linux-x64.zip"
    sha256 "ef6a3050a1c3477a6e13c24d10ab36decad548649a260559d466467401db15de"
  end
  version "1.8.0-212"

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
