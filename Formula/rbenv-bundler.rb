class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/1.00.tar.gz"
  sha256 "84f5456b1ac8ea4554db8fa17c99b5f5d2eafcd647f85088a5d36e805c092ba7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/carsomyr/rbenv-bundler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a97f645dd6ce27ab061359755b48f6ab5abda44a96377e2f8e8450e2e5576a03"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundler.bash", shell_output("rbenv hooks exec")
  end
end
