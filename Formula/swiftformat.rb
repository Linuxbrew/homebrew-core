class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.2.tar.gz"
  sha256 "29acf27cc69bbad7df483c612fc24de9117fc81bd2700bfb5b1b177f6883cb60"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "c60ef5fb21b0130c1a1d85c21d3138f4558d3488d6217eb2bc0f272f951ab59a" => :catalina
    sha256 "bcb75d07c1cb2edcd6ae3556b120e76f592c5d1a45b44ff058056b27f9347781" => :mojave
    sha256 "2dfddc61bfe3491a677794119d43992b7b2709d63e540a28ac4ab59d19b0a98e" => :high_sierra
  end

  depends_on xcode: ["10.1", :build]
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
