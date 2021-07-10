class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/1.0.1.tar.gz"
  sha256 "6840d4165242da4606cd246ee77d484a91ee926331c5a6f840847ce189f54d74"
  license "Apache-2.0"
  head "https://github.com/carsomyr/rbenv-bundler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b3c53b05f0504b05399bd47595ef5134e91c1a15475765550498b027d135a8c" # linuxbrew-core
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundler.bash", shell_output("rbenv hooks exec")
  end
end
