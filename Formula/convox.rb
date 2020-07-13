class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.29.tar.gz"
  sha256 "31c74af451d68c14a0a927f96afb81dbe937d4971e3974484578109dc14a9f81"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4c474d0ddc76dea24082749a417c71fed6fabcc0541dfadda7837aa684a4b28b" => :catalina
    sha256 "1e43eaf8bcf60ac01900626164c4c50914f09b742855888abc94bc3c495019b9" => :mojave
    sha256 "0f4f9423595e353ae5d599826d106a8e1fd460ebcb440333653de44d3916955b" => :high_sierra
    sha256 "d7a6db7455b8fcb0f90664ad89a1e3fadfedf011085092d6c92102ae57cada02" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
            "-o", bin/"convox", "-v", "./cmd/convox"
    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
