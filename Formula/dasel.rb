class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.5.tar.gz"
  sha256 "369b546b2dea471c612685382db908a432ba3128f6e3a921d5daef7a8164762e"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ffec5af1f9c5673db8a4338805808cc6b2242adb0324677d5a67795b6eda6c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d68f9effd39f28030ff60ad52ac3650f29137f2a7f7f8971a1f691caa222f84"
    sha256 cellar: :any_skip_relocation, catalina:      "b50ae359af658744ef8a812d3fee477204136553583d27549d8a25c2dac762ef"
    sha256 cellar: :any_skip_relocation, mojave:        "9e4d39775e5d0dcecd058894975f1005b2c97b43878ac1f7c5f4a2bbc879a58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715b1ad103b0243020ee64b766100734ed12a6cd13a8430bbc207fab0d5fc6e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
