class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.1.tar.gz"
  sha256 "47c028792caf69fbfa8dd8e1c989555d09141de8cea5154ae71e8b34845f601a"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :catalina
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :mojave
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "tarantool"

  def install
    system "cmake", ".", *std_cmake_args, "-DVERSION=#{version}"
    system "make"
    system "make", "install"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
