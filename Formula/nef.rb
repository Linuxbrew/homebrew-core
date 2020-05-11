class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.6.1.tar.gz"
  sha256 "182d5f91e3048f046a63bf81d148f94acc7c667b5314cf76f36a9fb75efdb3a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "db1f3b419794b096f913f805f08b56e0f51cb01cfa20d4a8bfd77cc6ae1f236c" => :catalina
  end

  depends_on :xcode => "11.4"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exist "#{testpath}/nef/library/apis.md", :exist?
  end
end
