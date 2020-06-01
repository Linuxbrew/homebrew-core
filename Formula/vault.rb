# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.4.2",
      :revision => "18f1c494be8b06788c2fdda1a4296eb3c4b174ce"
  revision 1
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4d90715d6b26da055402b19c8ed37a4dece5f913402ad24326bc6f002482f7f" => :catalina
    sha256 "966faf03179f1d0a9944133d72e31058cc868a9c3a1b51f54130466967e04eb4" => :mojave
    sha256 "b927910389472f03244c0e42058c31059169db9de2085dd9c1b536116e402097" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@10" => :build if OS.mac?
  depends_on "node" => :build unless OS.mac?
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    ENV.prepend_path "PATH", buildpath/"bin"

    cd "src/github.com/hashicorp/vault" do
      system "make", "bootstrap", "static-dist", "dev-ui"
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "vault server -dev"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/vault</string>
            <string>server</string>
            <string>-dev</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/vault.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/vault.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
