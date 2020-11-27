class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20201126.tar.gz"
  sha256 "cb4cc62fe6a9f3452f20ada676996b48039f091bdae25943955ac9e2299a9c09"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccf86448023fc2dd6c2f1fd27d546c792cb36461232297f40516c2c76fe2c204" => :big_sur
    sha256 "dafe72ff9e16d91f82d981cd132d16a94086324f102349e0163220aa7b316738" => :catalina
    sha256 "d79906ade24842ef8df0b5713f3dc16e4c10ae2e0d0ea1017c91a2e5c40bf132" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_client", "github.com/xtaci/kcptun/client"
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_server", "github.com/xtaci/kcptun/server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/kcptun/bin/kcptun_client -c #{HOMEBREW_PREFIX}/etc/kcptun_client.json"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/kcptun_client</string>
            <string>-c</string>
            <string>#{etc}/kcptun_client.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kcptun.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kcptun.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
