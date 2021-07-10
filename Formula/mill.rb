class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.9.8/0.9.8-assembly"
  sha256 "0246eba6c743d17003f31916c83d74a7fd95898423c95abcc549dbad3546f7b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e823aa9b5e31f4b17b381933f2293c430c476783a25562cf350eec055157a07" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
