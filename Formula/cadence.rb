class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.1.tar.gz"
  sha256 "510abecfb46422c500b5d1baafe4b41552e5dc22aab09d9a0b2d32d5176df87a"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d275cc33878b70f2e3b1955fee239efb3c01fb10cbb139a8f66a5fdef9159ec7"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e938c3e9220d8146d77c00a7eab2eaf8108aa92829a7672c24fe0e54edf7e5f"
    sha256 cellar: :any_skip_relocation, catalina:      "33534daaf7c1df0c0c8dfc621e55529141ea74034e35418cf5f162f7f7c099d2"
    sha256 cellar: :any_skip_relocation, mojave:        "9401473694dc3d18f7a17d4132dc06bd39268c6395e9f905adc75b2b67b5d3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e0d9072f54b600058d1c98c7c0d78afa8350ab30765ec9c47f6901e943d88c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
