class Ballerina < Formula
  desc "A Programming Language for Network Distributed Applications"
  homepage "https://v1-0.ballerina.io"
  url "https://product-dist.ballerina.io/downloads/1.0.4/jballerina-1.0.4.zip"
  sha256 "cbc4d6534c57141b9f8832921a22fb1599ff5dc63c3d07238753ec28c0d8452b"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    inreplace ["bin/ballerina"] do |s|
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      s.gsub! /\r?/, ""
    end

    bin.install "bin/ballerina"
    libexec.install Dir["*"]
    # Add symlinks for the Language Server
    prefix.install_symlink libexec/"bre"
    prefix.install_symlink libexec/"lib"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
