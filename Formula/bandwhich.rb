# bandwhich: Build a bottle for Linux
class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.10.0.tar.gz"
  sha256 "33966794c8689a4d6e16bf1c8e615377ed58773bf653ac547e109b0cce12a705"

  bottle do
    cellar :any_skip_relocation
    sha256 "be61a88fcc4db486997852567b8f3f63519ca3e496e6bd3c70d14f839b992b6c" => :catalina
    sha256 "b25bc4e540777cae90d8101afe6bd3c888cb3e87126cb5ac38bd467cccdaa97e" => :mojave
    sha256 "67ae6ace43332da1fd0ed1dcc7ce4c4643cffc9d517ebe2469c6518b8ad08074" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
