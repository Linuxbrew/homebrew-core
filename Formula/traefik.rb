# traefik: Build a bottle for Linux
class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v2.1.0/traefik-v2.1.0.src.tar.gz"
  version "2.1.0"
  sha256 "2b360fc45b5183a69127b3741459c9c41e76a5db820599c813dee7f46b170df7"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee8efc5c8dcacb78e374e0eab8f40160ea0f9994664dd167bd4324d42a23991d" => :catalina
    sha256 "389194e6fc855dc6f81af133431a9b5db87ef562798b40ecf84b32f31c17d46c" => :mojave
    sha256 "e4340b05062bfb3d0ca1af1269b9837d3f56060bc828e437ac5bc543c3cf1fb8" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    cd "src/github.com/containous/traefik" do
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
    require "socket"

    ui_server = TCPServer.new(0)
    http_server = TCPServer.new(0)
    ui_port = ui_server.addr[1]
    http_port = http_server.addr[1]
    ui_server.close
    http_server.close

    (testpath/"traefik.toml").write <<~EOS
      [global]
        checkNewVersion = false
        sendAnonymousUsage = false
      [serversTransport]
        insecureSkipVerify = true
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [log]
        level = "ERROR"
        format = "common"
      [accessLog]
        format = "common"
      [api]
        insecure = true
        dashboard = true
        debug = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_http = "curl -sIm3 -XGET http://localhost:#{http_port}/"
      assert_match /404 Not Found/m, shell_output(cmd_http)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://localhost:#{ui_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd_ui)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
