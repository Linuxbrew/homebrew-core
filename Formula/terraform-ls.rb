class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.16.1.tar.gz"
  sha256 "e466d782fd1e2bede2f90e5677e1fd18df4a23476ebb08212502a3e955667736"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18de6f811fbb10fa27afe5fddcc76711b707128a6708052eaa52676861b6c43e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4d030c3b8834e0ceb2a94c4ef2e63755c5f3620e444ae51d66da527ca5d0d61"
    sha256 cellar: :any_skip_relocation, catalina:      "44b60512f79644f4c5ba341c7a9d2770118d66e42697db5c8537d38ed5bffcf0"
    sha256 cellar: :any_skip_relocation, mojave:        "1f509b7dfed66791a5feb37eaad738d503b29404df324ea0f78536e9992fd53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd33e9c25cdbb48e25bf462eb493eee0ebc9abee92c7db4170055536d2c232e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
