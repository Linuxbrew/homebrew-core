class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.7.25/traefik-v1.7.25.src.tar.gz"
  version "1.7.25"
  sha256 "5eb1bb7eedf687c3321d27aa3813d739935dca19099425b6f4bf56f4727dde4b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1c8a568a945d2f3e11d142efffdd85341f10f676c81e9d5b8c325d60aea83c" => :catalina
    sha256 "2e22cc73a1978720ae7a71da3f98b7fe7c74ee71c225a607197de2af6dbc7aa3" => :mojave
    sha256 "bd3ee1dd647f8fa10a85c22481ef52ea2e2ad649b04f648dd9a56f08bea6f52f" => :high_sierra
    sha256 "044f25988f40ff57322bd07309c794f15232b1a11455cc4641cbd97dc468059e" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    cd "src/github.com/containous/traefik" do
      cd "webui" do
        system "yarn", "upgrade"
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "traefik"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/traefik</string>
            <string>--configfile=#{etc/"traefik/traefik.toml"}</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/traefik.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/traefik.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    web_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [web]
        address = ":#{web_port}"
      [entryPoints.http]
        address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match /404 Not Found/m, shell_output(cmd)
      sleep 1
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
