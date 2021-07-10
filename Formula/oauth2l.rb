class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.2.1.tar.gz"
  sha256 "25b1ab24fc68340b80ed701cb9df80f29b6772bf396bb0d41a21b456390a3de8"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3aea8afbb2cd4a8b2846a34c18142e12c891ff64ca571b2776740b15169d4d81"
    sha256 cellar: :any_skip_relocation, big_sur:       "4dca4d631a0388afbd9131b4b158447cedafc4633a304b1efe70f05e1f61abb4"
    sha256 cellar: :any_skip_relocation, catalina:      "3b1a5b18dd885380288d7fe05cccb1a4928583e645b0923a32035311ac7ee88e"
    sha256 cellar: :any_skip_relocation, mojave:        "4bbc795be26dc48c91cf5ed9393d65e66f410e742b99ac532919ed0c547f5e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c59a0cf656324faec4f3d728dbdf2887d5808d20ab36bdb696afbeee854221" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
