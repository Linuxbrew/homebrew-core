require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.17.1.tgz"
  sha256 "761f94c5ef86dbe584e28aaf8c1b452098befe5405b6192256e881884c242169"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00bc4e335d12186bf65e6f5fc26a5887815124489dcd8bfad4fcf1ac51e9f3d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad7323a78e679d8d7eb7b8a597e6f70435b21dc20b9819d21bc29d535dd908a5"
    sha256 cellar: :any_skip_relocation, catalina:      "ad7323a78e679d8d7eb7b8a597e6f70435b21dc20b9819d21bc29d535dd908a5"
    sha256 cellar: :any_skip_relocation, mojave:        "ad7323a78e679d8d7eb7b8a597e6f70435b21dc20b9819d21bc29d535dd908a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c38d12c4a7eb2d462728b8688699202eaea6de289ae9afbe72cbd1a0d0af9e8" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
