# teleport: Build a bottle for Linux
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.1.7.tar.gz"
  sha256 "e1661d7d745616f5a3903050650c6c0d7f5eace454c447523821c4e96f00c786"
  head "https://github.com/gravitational/teleport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2e3e4743e28352cede7456f53cb29c0320b08d1cd92e3063dc25d526b26be70" => :catalina
    sha256 "f90497d0a8a515aa7264e620038148c9f5001c57b4864810e9d347dabb4fe4b8" => :mojave
    sha256 "5b4006cb4d4d377c8647ee23c3820f4667aa1c9c0e6fe5e12973f4404132ce95" => :high_sierra
  end

  depends_on "go" => :build
  unless OS.mac?
    depends_on "zip"
    depends_on "curl" => :test
    depends_on "netcat" => :test
  end

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = OS.mac? ? "darwin" : "linux"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
      (prefix/"web").install "web/dist" unless OS.mac?
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    unless OS.mac?
      inreplace testpath/"config.yml", "/usr/bin/hostname", "/bin/hostname"
      inreplace testpath/"config.yml", "/usr/bin/uname", "/bin/uname"
    end
    begin
      debug = OS.mac? ? "" : "DEBUG=1 "
      pid = spawn("#{debug}#{bin}/teleport start -c #{testpath}/config.yml")
      if OS.mac?
        sleep 5
        path = OS.mac? ? "/usr/bin/" : ""
        system "#{path}curl", "--insecure", "https://localhost:3080"
        # Fails on Linux:
        # Failed to update cache: \nERROR REPORT:\nOriginal Error:
        # *trace.NotFoundError open /tmp/teleport-test-20190120-15973-1hx2ui3/cache/auth/localCluster:
        # no such file or directory
        system "#{path}nc", "-z", "localhost", "3022"
        system "#{path}nc", "-z", "localhost", "3023"
        system "#{path}nc", "-z", "localhost", "3025"
      end
    ensure
      Process.kill(9, pid)
    end
  end
end
