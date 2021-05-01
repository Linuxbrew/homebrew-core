class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.38.3.tar.gz"
  sha256 "b06d2bf63fd08d8a92d51824f69e41345bd90d747d444ca37770b2017a2a5a00"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b62a3435c83d8b49147192ce9b6627b4a27705aed17e78b6e0601882ce17621"
    sha256 cellar: :any_skip_relocation, big_sur:       "22291c2a1266367077d35e129e753279faa023b862fe249fa7e69b4ea948d737"
    sha256 cellar: :any_skip_relocation, catalina:      "cbbe8abf3cbf92b1860da4a48577676a744bcceb44e66d2cc2307c7414244385"
    sha256 cellar: :any_skip_relocation, mojave:        "1d26ccd44c19d2eeff908e9c69a2558d4ac682e21506a05ccc3d55bb3ff1295e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202104300531/geoip.dat"
    sha256 "0190fcdc8de045be8454270f514cf28ebcb8a5844c3d4aee7784d70bee9d3a6b"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210430100800/dlc.dat"
    sha256 "8bd12f2b349aea03c63c3c75aa8fdc8448ea0addf1ffbcee9b908e1b6308e172"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  plist_options manual: "v2ray -config=#{HOMEBREW_PREFIX}/etc/v2ray/config.json"

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
            <string>#{bin}/v2ray</string>
            <string>-config</string>
            <string>#{etc}/v2ray/config.json</string>
          </array>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
