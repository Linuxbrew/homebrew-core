class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.9.2.tar.gz"
  sha256 "154f00e0a8bf35d6ea9028886c3dc5c3c342dd1a367df55ef29a547b75867f07"
  license "MIT"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d65c7dd41ac16cb2f791a80f3cbebdb6616321e106874504644b0ab5cd37da24" => :catalina
    sha256 "14f512383b868d8c9752414328fd4681de70d6aa37992cdcb55be61406bcb08a" => :mojave
    sha256 "6b920612afb160b31950f28dad5b38880689cb3f52a23be723e8dd680370fca8" => :high_sierra
    sha256 "bb268a068c9424beeddb9933a57aa9593c6cd4ffceb58dab58d14368509081eb" => :x86_64_linux
  end

  def install
    system "make" unless OS.mac?
    system "make", "LDLIBS=''" if OS.mac?
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    if OS.mac?
      expected = <<~EOS
        Couldn't tweak forwarding knob.: Operation not permitted
        kernel_setup failed.
      EOS
      assert_equal expected, (testpath/"test.log").read
    else
      assert_match "kernel_setup failed", (testpath/"test.log").read
    end
  end
end
