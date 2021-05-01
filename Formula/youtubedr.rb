class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.6.1.tar.gz"
  sha256 "8f42e8807dd37bbb2d3ebb053bda81cdcaf8fab0ba5d75ea8ca2007f5f4d1e58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83514c2bd18be0eea281272629865ac833e9e26aab80799392648d1db989747e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d929ce0d785f31dc55d0cd29f01dfccf2f7c850a2c0740545292f5f4d93b9db6"
    sha256 cellar: :any_skip_relocation, catalina:      "4454b14668fe574445455408de68cb6ffa8846925750ee6a43be7f5bdf720a13"
    sha256 cellar: :any_skip_relocation, mojave:        "8bfe83fde8866d3603e9acba1112c8ba4e99a3250af5b81aee98370b49f9d35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "489c1d8a566f63e7532263a162e5e343aa33389bc1e1c95f5d35ffb2502f9f69"
  end

  depends_on "go" => :build

  def install
    build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

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
