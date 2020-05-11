class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.1.tar.gz"
  sha256 "bae4202983c39d7546a0a464ada00faf9263ac186d8426f0497fefab0abb5eea"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "02d2278130af5411ae369f4ca9ce72ef052108d8e6cfebd3f83c53e90f12d57b" => :catalina
    sha256 "02d2278130af5411ae369f4ca9ce72ef052108d8e6cfebd3f83c53e90f12d57b" => :mojave
    sha256 "02d2278130af5411ae369f4ca9ce72ef052108d8e6cfebd3f83c53e90f12d57b" => :high_sierra
    sha256 "ccec7fa1a5dc0f97c6426fcc7a5315490bafa52f6929ec74ba0e5025856b3525" => :x86_64_linux
  end

  depends_on "protobuf"
  depends_on "python@3.8"

  conflicts_with "mesos",
    :because => "they depend on an incompatible version of protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python$},
                                       "#!/usr/bin/env #{Formula["python@3.8"].opt_bin}/python3"
      libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"
      bin.install_symlink libexec/"protoc-gen-nanopb", libexec/"nanopb_generator.py"
    end
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
