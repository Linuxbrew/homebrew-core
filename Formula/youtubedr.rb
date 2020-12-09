class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.3.0.tar.gz"
  sha256 "359c271b641675e20842e5e5146708b477869e55988927dd9610c2a03311f55f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6956fea8197b2302b6b5e31077d3c71a043e1bd1c0aadd5cb13691c1a569d94f" => :big_sur
    sha256 "39c6fdca870d0ce13ac4888f8671bbe5cb2e1628da753b38b701e2989e496dde" => :catalina
    sha256 "e8953674953c78d36207f9584f720f4a511690b1b9862a2ce564cb7c30f79f8b" => :mojave
  end

  depends_on "go" => :build

  def install
    build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{build_time}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
