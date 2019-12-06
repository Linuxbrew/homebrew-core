# berglas: Build a bottle for Linux
class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.4.0.tar.gz"
  sha256 "776468072b90b8cb68e063fe1e01be581a217b00bc68febeed19cb23a28d0e04"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fa9dfc12fcb5341c8d3d5a6430823134c133a4ff59234ae06baceca4b7bc056" => :catalina
    sha256 "d3eeb994d85c737d1a1b5d47d198e67fa096bde3c5094bd34396292f08fd43f7" => :mojave
    sha256 "45096c7ccf9eca67bf048659df8e8b166d78142776d8e8ed981c5d32d7a152da" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"berglas"
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
