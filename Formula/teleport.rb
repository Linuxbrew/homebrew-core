class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.3.0.tar.gz"
  sha256 "dbc2cd029efdd3df5cc12a8105cb80358202878baed21ca65442d678c0f28f61"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cc353435bf3c84f759cdf77bea38ca2510be51398b810b2381a3a27b44bac34" => :catalina
    sha256 "64bae136e0cd999903a68af31f5bfb46eadfbeb826053a748818b171029c5b29" => :mojave
    sha256 "6c701a0d953456385b454027bb69a1d974f2210ad9e209912abb931d6c27e055" => :high_sierra
    sha256 "30e122b8750d39584b960d54d523e65c4700675279f45b810765cd214414909f" => :x86_64_linux
  end

  depends_on "go" => :build
  unless OS.mac?
    depends_on "zip"
    depends_on "curl" => :test
    depends_on "netcat" => :test
  end

  uses_from_macos "curl" => :test
  uses_from_macos "zip"

  on_linux do
    depends_on "netcat" => :test
  end

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/72412062d6d55ec7faa9707abf500d703e7d09da.tar.gz"
    sha256 "c84767bea0a723f406e3b6566a0a48892758b2e5f3a9e9b453d22171315fd29d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"webassets").install resource("webassets")
    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
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
