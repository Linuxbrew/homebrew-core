class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.15.1.tar.gz"
  sha256 "f9dfc967b9184e57ed68125f0e8e8d7021308916f391977a13e3e8ebe3e6aeda"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e9a5ec79e2f665284c51e4b8aa726028e218c852ea37954535a59f4d0147003"
    sha256 cellar: :any_skip_relocation, big_sur:       "abd65a00f45202ce36b85bc49bad645a449be1758f4f848544694776884140fe"
    sha256 cellar: :any_skip_relocation, catalina:      "9fc31cfb6e9cbeefc41dfbc0b8dba766865d287ffe18d53ce3ed6e468b27c8b3"
    sha256 cellar: :any_skip_relocation, mojave:        "b96d6c1c283ad4b084364d60a6f10f8e7bfbba227e2e61b824fe145cb89b2095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a8d8f7203c5762f55deec643874c3fa0faaf664aef1d4ef210b313e09cf079"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
