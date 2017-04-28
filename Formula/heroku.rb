class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  if OS.mac?
    url "https://cli-assets.heroku.com/branches/stable/5.8.11-0e9b5ce/heroku-v5.8.11-0e9b5ce-darwin-amd64.tar.xz"
    sha256 "613544bf6b9585ee5f453471543984f847325575d5c95e91a46a4b8b2a10cf70"
  elsif OS.linux?
    url "https://cli-assets.heroku.com/branches/stable/5.8.11-0e9b5ce/heroku-v5.8.11-0e9b5ce-linux-amd64.tar.xz"
    sha256 "e27cdc043ae25f323d8da7ba5705f6a9974708c0a0669d68898f86554f69dd97"
  end
  version "5.8.11"

  bottle :unneeded

  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/heroku"
  end

  test do
    system bin/"heroku", "version"
  end
end
