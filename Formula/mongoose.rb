# mongoose: Build a bottle for Linuxbrew
class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.7.tar.gz"
  sha256 "ccc971298db70963d3f13766c3246a3c36ae7e388acfab7ba2180149d9c8c64f"

  bottle do
    cellar :any
    sha256 "6a3df8d1cb63d469e65fbf63de3f1c5b67b64cab24c5880f1a7c514a87ca0489" => :sierra
    sha256 "4fab01e485b8c62687c8894815225ec60a7b2b057d11cafaa7c1a4b8027968ae" => :el_capitan
    sha256 "221024243b628f9749d489d99feef622effca3fbcb07de66271363b38ac7be26" => :yosemite
    sha256 "86be84258b97a4c5be926394de32e79be35ebe7e8276034b0cd2ef4c77dd518b" => :x86_64_linux
  end

  depends_on "openssl" => :recommended

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/blob/master/docs/Usage.md
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    if OS.mac?
      system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
      lib.install "libmongoose.dylib"
    else
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
      lib.install "libmongoose.so"
    end
    include.install "mongoose.h"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<-EOS.undent
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
