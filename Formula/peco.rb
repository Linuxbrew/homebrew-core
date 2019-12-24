# peco: Build a bottle for Linux
class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.4.tar.gz"
  sha256 "06636082070634256b5adc4c24955ad2c520b24fec528131d0ce203c31aa209d"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ea47db32f650d926abfeba4ebc210de96a8eb28bd0677acf1eb8fa7ddc365e4" => :catalina
    sha256 "424c1cd6b0c9d331f65be9cf17f0ca6cd03489fec412f1ad0f4cd067f2a16b93" => :mojave
    sha256 "4422802e055e8b7c47f9a31aac5a9e868d9d1f92818514ecc4b13aa49fa32d9e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "make", "build"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
