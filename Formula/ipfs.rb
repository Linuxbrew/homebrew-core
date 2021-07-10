class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.io/"
  url "https://github.com/ipfs/go-ipfs.git",
      tag:      "v0.9.0",
      revision: "179d1d15079ab331648023670b766604c764dc17"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/go-ipfs.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "082d26de8a7fb59d605f9d041bb60c73e018bc8d68bdb261ad96bfcb84cde64a"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf27a87766f08ae1164b07e4764cc23022c90e61a7a09ef4933772ba780cf7be"
    sha256 cellar: :any_skip_relocation, catalina:      "25fed340fbbb800032ade9a9b8e336dd1a281677d212b0045ad3ac5d25c8230b"
    sha256 cellar: :any_skip_relocation, mojave:        "99ecea05edda6979e511ef1a81064beb45469b258d9ae6ddf9a551b1bbb44ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bcb3484a5b2b9cc468cbcee9a7a60f36a2feba8e101f4574e647f0877215821" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    bash_completion.install "misc/completion/ipfs-completion.bash"
  end

  plist_options manual: "ipfs daemon"

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
          <string>#{opt_bin}/ipfs</string>
          <string>daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
