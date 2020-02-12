class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.1.tar.gz"
  sha256 "18be4bf40f25c7f94ae28dbc5751bad11aa7ed4cd832e4a738e54e4f20798df7"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47903eeb2b4d76d81ed069ae695baece1906b69b02acc86e0e5fcd26010873df" => :catalina
    sha256 "41dadf44fd4b9615e44cab2dbc7e53cbc6382876fbd7f62bfb072b1b93f01aaa" => :mojave
    sha256 "b3c6b8ed0b9b4c245f931bd6a211040d6e6db55cbddfeea8c7f5754ecaa62e41" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    if OS.mac?
      assert_match "Is the docker daemon running?", output
    else
      assert_match "no containers to remove", output
    end
  end
end
