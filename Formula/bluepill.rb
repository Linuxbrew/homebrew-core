class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.2.2", :revision => "89010caaff60e75e23d612d3d60a1efd7b2e2b99"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0670232c1218eafe49bcdc694cf288f0cb88137dcbfce12fa7c991a523eb873f" => :catalina
    sha256 "68dcc80fd4cc0e3d685251330680702b05fc898824537639bfdea08a094fea29" => :mojave
  end

  depends_on :xcode => ["11.2", :build] if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
