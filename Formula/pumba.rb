# pumba: Build a bottle for Linux
class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.8.tar.gz"
  sha256 "53e4eef967620e114585627d34766caa061cf96a309b8e1a914808f90a59d49a"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b08f11926f2c2b219cb860602f5a25afc4c9fca7948f66eed28bb028a1e7f991" => :catalina
    sha256 "f01102821fd050f1c85fffb8eeeab1b4aeacf6011a6614baeff50b6f7652f838" => :mojave
    sha256 "5466fd176df0a225e25364e7f94ef80359405b923229970c74f0246074ddf69b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/alexei-led/pumba"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}", "./cmd"
      prefix.install_metafiles
    end
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
