class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.3.8.tar.gz"
  sha256 "78dda45f508ea699e762aec3a9160e8cec069f5af7bba722f09f2278eda9050d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cc176df89297e8589b4e7beeb2c814c13a1b77cfcedb1e7e5325141ea51dc9c" => :catalina
    sha256 "4c9dd93b4a0c62148ec01cee562cf530745894e839f7f6b6a10b1d8b084bfda8" => :mojave
    sha256 "d141ce3e5e480fe402cc844c8e0e350380dc3973fa6d02d7146e173b125923ad" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
