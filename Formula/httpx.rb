class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://projectdiscovery.io/open-source"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.1.tar.gz"
  sha256 "8ae65c0cc471f6fb066d5662ffb5ae45979dcbcaddad9df795776f5320ce7ef3"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d7fdb697d1a2c6295b7c9ecc685007ee38ae4b17752283028aec50494d792cf" => :catalina
    sha256 "09fc321f4f84348e51b8c791ed3184733aba87584a232bc5eaac0afb1fc42d64" => :mojave
    sha256 "eb3d6bbb28a94e7c98cc9cedbb4b3ff765a6a9660df5ff9ef1206aff756d6e56" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
