class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.21.tar.gz"
  sha256 "ee0a031bd096766046af7904595685bb154d3d3f777123615fefa4c5927f9a59"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a3533e4deb8716cd7fcac136942594df2ae9207ff82f5826d111dcfbfc7a4d1" => :big_sur
    sha256 "4775a922d6d8c7a212b9f19ac4a79da1eda3a4302a26cd1f5eec7db003db44d2" => :catalina
    sha256 "1b241c193fb22f5efac69aa76a3af7dd1859feb9e79e8fc1a5d6726adb975ca1" => :mojave
  end

  depends_on xcode: "11.0"

  resource "test_log" do
    url "https://github.com/tinder-maxwellelliott/XCLogParser/releases/download/0.2.9/test.xcactivitylog"
    sha256 "bfcad64404f86340b13524362c1b71ef8ac906ba230bdf074514b96475dd5dca"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource("test_log").stage(testpath)
    shell_output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    match_data = shell_output.match(/"title" : "(Run custom shell script 'Run Script')"/)
    assert_equal "Run custom shell script 'Run Script'", match_data[1]
  end
end
