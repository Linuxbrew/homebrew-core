class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.9.tar.gz"
  sha256 "6c39c266f5fc177ca135e73dcf090dd14f800d4f95d2af98ee7724faf46b4390"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "20066e7f5becea0099f05dc510634d5193799c4bb5e0e25d6fc6be318e812964" => :catalina
    sha256 "ff9622c427d88dadc5b0f6348d47044e85ba45e55449ca506687b3773172e2d1" => :mojave
    sha256 "2dab824409448a41181ae6e41bd6e6a32f9fe373e104b87891ad4327993a870f" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build] if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
