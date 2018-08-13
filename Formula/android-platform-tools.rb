class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/studio/releases/platform-tools.html"
  # the url is from:
  # https://dl.google.com/android/repository/repository-12.xml
  version "25.0.4"
  url "https://dl.google.com/android/repository/platform-tools_r#{version}-#{OS.mac? ? "darwin" : "linux"}.zip"
  if OS.mac?
    sha256 "02eb6ed288bd8f02c00266e5ba8adacf07cb56f2546c5fe4ccf27719aa732947"
  elsif OS.linux?
    sha256 "79048c41f69e730800d4fb710f6128691b7b8dfcb3a280e6b4e112a6f9285cbf"
  end

  bottle :unneeded

  depends_on :macos => :mountain_lion

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end

  test do
    system bin/"fastboot --version"
    system bin/"adb version"
  end
end
