class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.0.tar.gz"
  sha256 "f3f102d3c0448baf762c814d2952eec90dc56347f87e27346ecd36a5e2c9515d"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0fbaaa69708c0027ea886e1cdf6fa243390a6910ca8178861c1f7b5af0edd296"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cb1e78d2639fc154290ede3d781bf23149b232e058fa3e298bb829ecbd71105"
    sha256 cellar: :any_skip_relocation, catalina:      "252885e8c8d959c4042d7e5b63ea02a54d8b78693262ce0b0da4d593ba692a84"
    sha256 cellar: :any_skip_relocation, mojave:        "867ad2f99751771199f46051edeb2d8d08152b1adeb1d4512aca7f68ad2511a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1172c657d447937cc92fd5e7ea9f3f62fc8ed974f143cbba80f079aaebffd95d" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  plist_options manual: "syncthing"

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
            <string>#{opt_bin}/syncthing</string>
            <string>-no-browser</string>
            <string>-no-restart</string>
          </array>
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
          <string>#{var}/log/syncthing.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/syncthing.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
