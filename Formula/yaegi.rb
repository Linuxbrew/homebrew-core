class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.8.tar.gz"
  sha256 "2085aa7f169c58eeaf2082b12b59cac6ff329a87642735613127618e8a1aec62"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "144f6a79dd8538807c32f360eeea485bed53ce4e9d4fce68119188d6ae8eace3" => :big_sur
    sha256 "6597eb7396575eb91e3e68dc0cfcb1525b1f92c48256a55888d953e190fe3ea7" => :catalina
    sha256 "8adbcfb6777e54f80c465c709e7ff9e93bb8ef87c65cb43589ddec3084898624" => :mojave
    sha256 "89e92ab488d9046ab0df3d3ed1b9de408628d52943850804f360afe14e248a9f" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
