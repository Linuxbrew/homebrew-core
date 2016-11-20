class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  version "24"

  # the url is from:
  # https://dl.google.com/android/repository/repository-12.xml
  if OS.mac?
    url "https://dl.google.com/android/repository/platform-tools_r24-macosx.zip"
    sha256 "5eb758fe3ddddd8e522c17244bbcb886f399529855bad60c8ba14711dc5a8a12"
  elsif OS.linux?
    url "https://dl.google.com/android/repository/platform-tools_r24-linux.zip"
    sha256 "ef1672ecc3430bb11511fce57370f28b0db47d37df7f1b3298970880b2e221de"
  end

  bottle :unneeded

  depends_on :macos => :mountain_lion

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
