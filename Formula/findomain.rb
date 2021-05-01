class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/4.1.0.tar.gz"
  sha256 "d0a71b54c51e5ad6104bf71d0c4a53c255a81ca334c314b711227a765292dddf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "483824d17552b08b53ffe68b82ebb05cd3b8e967697606de87c7da53bd0db535"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a024f4ac2a885b7a00cf896ed64dd517bcd8bea4febf9fd88c2db055f860a76"
    sha256 cellar: :any_skip_relocation, catalina:      "f15811978851a78b040aa4baa087ad232658a00d213cd3f2a521daa6afc23a7a"
    sha256 cellar: :any_skip_relocation, mojave:        "0f00d7b449da6d3e93ff843a726324bdc291160989a18950921d854bd1ac13b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab0741fe920f0fb274ee44a6164c64a6cf7f1e4beb18e8bd359fc2bac2febb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
