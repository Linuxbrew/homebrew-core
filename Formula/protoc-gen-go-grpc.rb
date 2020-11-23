class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.0.1.tar.gz"
  sha256 "01bfd13d2140ff671fcb826d114d091f71b921102337ea730a9c21f8272fc655"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "efae87531b44a132d58058ae94017d0230dc18e2ccba755fee48629240265016" => :big_sur
    sha256 "06248f002516f5265c1885a53e9a636a0c7e4f202a8383fbbc02c39ef683a25f" => :catalina
    sha256 "ce5dcf277a02a3130c5da382521d1a3ca3e6e26ff715a6f44cf18ce52e6e10df" => :mojave
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    cd "cmd/protoc-gen-go-grpc" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"service.proto").write <<~EOS
      syntax = "proto3";

      option go_package = ".;proto";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    EOS

    system "protoc", "--plugin=#{bin}/protoc-gen-go-grpc", "--go-grpc_out=.", "service.proto"

    assert_predicate testpath/"service_grpc.pb.go", :exist?
  end
end
