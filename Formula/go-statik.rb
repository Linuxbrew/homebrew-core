class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.4.tar.gz"
  sha256 "3f547d8d2033b1b16a3549f48b69e8671a64fd6b18aea2322007f54c837d1dde"

  bottle do
    cellar :any_skip_relocation
    sha256 "18339f5e80245b9bc68e34ff1b20a049174bdf5204b8db52c11259c9b4906e2f" => :mojave
    sha256 "0d487e1428fd79d04c28d9b355c4ce22f090868b35f90e6f21c7bf6c0e801ff6" => :high_sierra
    sha256 "f6e4f1d7b34a2598e75bd8172b948646d78d08e2f6b096404fd365e3673d2a48" => :sierra
    sha256 "5c07aec9cad77dc1d0ace389456cb30c331f943f63eb2d5fa4af117bd6c4b960" => :el_capitan
    sha256 "3e6024664e248d458d4af08d6b969c28674c3600fd1c194f4af60248d87f2578" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"statik", "-src", OS.mac? ? "/Library/Fonts/STIXGeneral.otf" : "/bin/ls"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
