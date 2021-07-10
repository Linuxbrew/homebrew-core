class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/4.1.1/vertx-stack-manager-4.1.1-full.tar.gz"
  sha256 "5bdb2664be1c3f096566ae1d4cdf7ab429674da4361bf4bf1755a57daf82fbe0"
  license any_of: ["EPL-2.0", "Apache-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b1327cc13386a57f744b0a521b1bcb227e96205819f2410bcc80feac430a6ef0" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      import io.vertx.core.AbstractVerticle;
      public class HelloWorld extends AbstractVerticle {
        public void start() {
          System.out.println("Hello World!");
          vertx.close();
          System.exit(0);
        }
      }
    EOS
    output = shell_output("#{bin}/vertx run HelloWorld.java")
    assert_equal "Hello World!\n", output
  end
end
