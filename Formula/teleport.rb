# teleport: Build a bottle for Linuxbrew
class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.0.3.tar.gz"
  sha256 "89016f3eb20e82bc0dd6b4cfeb1b3afd33d89df638f2fdd2d85da03bf9ef23d1"
  head "https://github.com/gravitational/teleport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0df319c4b798962f6a4b69c679c615d2a4d49a123a19ea655e3797ee89860f15" => :mojave
    sha256 "8fbd56ee8d6cff21501c8f847f2d18f0b1120ef99176daf074aa99089c7ccabb" => :high_sierra
    sha256 "43f9ae8f7e8596bfc441d6955af613f2ab7e930cb11080c64601302e6061a15b" => :sierra
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
