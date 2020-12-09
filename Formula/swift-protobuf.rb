class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.14.0.tar.gz"
  sha256 "3bb458ab12170f7f19c7441fea5f72ed6642a0898f40adcb678e385d7d97c97c"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c8002f59a7713b667515a49ff07ba8b7f6e0ccf7e07ab7728d30c0c798549db" => :big_sur
    sha256 "16611fd3cc4130b4034dec99879de0d87456bb456450b90c7f47d9f412ead87f" => :catalina
    sha256 "1e06ca4ce5e773db5ab4674e45f0fd567ac27172bb3a8b1d7bee4c8f255a0e03" => :mojave
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    because: "both install `protoc-gen-swift` binaries"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end
