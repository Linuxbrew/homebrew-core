class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.169.0.tar.gz"
  sha256 "b4723c724ccf6091a309f4dd057077cb5f326ab3ffb4f8182bbcc8dcedebfc4b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "13b5ec495ad4d1d1e1c416e1d141940460d7e454ffbc3356132be541fac26601" => :big_sur
    sha256 "33f04e7632da832bc1a647d3ca8f2363580f49a130bb46a91dfe9f839248687d" => :catalina
    sha256 "7620b5805d448869996dc423e4f4a941dab7084031074061aad21a4643d0e887" => :mojave
    sha256 "6802f6b48206204254ccf70b14db5afea4997f31d40003c76c779ce39d5b7e7d" => :x86_64_linux
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
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
