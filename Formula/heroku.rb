class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  if OS.mac?
    url "https://cli-assets.heroku.com/branches/stable/5.6.28-2643c0a/heroku-v5.6.28-2643c0a-darwin-amd64.tar.xz"
    sha256 "7d0320800410821349a0f44be1ca49619388ef934e3ae2334b7c6b1f5028da95"
  elsif OS.linux?
    url "https://cli-assets.heroku.com/branches/stable/5.6.28-2643c0a/heroku-v5.6.28-2643c0a-linux-amd64.tar.xz"
    sha256 "bfc57ca6a30f55bb24ff166e489f305be8c26be22e2c9a323a73d8c2cce1a18f"
  end
  version "5.6.28-2643c0a"

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
