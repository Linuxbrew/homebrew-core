class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.5.tar.gz"
  sha256 "c1190b3c9cd805929a0a7330cda76f373cd638639006feff1784096bcaade872"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c328cd77044c3b8479c39304a2f4ff90a41223a462d1410744dd3df6044a7000" => :catalina
    sha256 "43b7c84825eaa3bc7133f9fd9fe7728be417bcc717333f7f8d547c70fe687aca" => :mojave
    sha256 "24ea156583c8da3be1178ef19069bf6b6424390799d35eb5c0113c3d32620e10" => :high_sierra
    sha256 "7231288a35608198541e42a7cdba001ba15c1ed2a3d624f4f5bcee48b90942d1" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
