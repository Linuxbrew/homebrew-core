class Openjdk < Formula
  # tag "linuxbrew"
  desc "Java Development Kit"
  homepage "https://github.com/ojdkbuild/"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u181-b13/jdk-8u181-ojdkbuild-linux-x64.zip"
    sha256 "fe5f5f8870e3195b0ee4c25c597b990ebbe8e667f3a345ff0afc49a8ff212dae"
  end
  version "1.8.0-181"

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
