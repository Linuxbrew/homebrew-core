class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.181.0.tar.gz"
  sha256 "b21a5a2b1cb62a3b45d0857538eab0c5d43be1962a7955b97250d805694a1a07"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c70c77579c31fb47d5af86d58f2693a08d3cb5ec663747d99401f5a13d334202"
    sha256 cellar: :any,                 big_sur:       "dde2eb0fbdba3f498eef993d6e63269d1dbd22fd4987806248c6583fad9c3deb"
    sha256 cellar: :any,                 catalina:      "c93e9eda1ff7a6c4a19598d1a00ab266c727ed1a92fa20422af080fbd1ede876"
    sha256 cellar: :any,                 mojave:        "82c110185c800a0af9df40afb325d6a8a075fe5218286c0994324001144f4c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2867c80c0800016b2c282b1dc0fba6cda88bbdc2f3746eafd28f105f453c4f69"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH"
      export FASTLANE_INSTALLED_VIA_HOMEBREW="true"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
