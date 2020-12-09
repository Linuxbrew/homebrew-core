class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.7.tar.gz"
  sha256 "452a6a3348ea4fc98df62a1ee3d5a97e24c6453d8a4a134ed4e0ece720a08d82"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d50fb2de6328778be4d657415d06132b0c465b8b6249bc5f490fa1e6860d5bb" => :big_sur
    sha256 "9d353a1d31c81486498c357c664441cbb3a2fa9c7d129819b926215ccf5448ce" => :catalina
    sha256 "e20a2edaa279d798d97578eabd40572563c115ecfc02f415f5c6746717086722" => :mojave
    sha256 "ade4d6be2837ce39516a2cb80ef1171a9475f76467a90a13af75ea43244bfe28" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
