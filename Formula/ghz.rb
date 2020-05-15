class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.52.0.tar.gz"
  sha256 "6f7e4e0cd81ad00c2c4e17c93257810e2ea8897f60713352c9d9583231e2739a"

  bottle do
    cellar :any_skip_relocation
    sha256 "37baf017141bf81d6607443c034e465b48c4694ff81d59220dd0bad6f0732f13" => :catalina
    sha256 "fd94085e4d3db4f73e72928cf24ec51085d60f71f54d93800e5cb56fa3bf7405" => :mojave
    sha256 "5f6f8cc187926b95fcc1ab071d3ca6c8e37af3981b6d3afae9d895b9b1ed0422" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
