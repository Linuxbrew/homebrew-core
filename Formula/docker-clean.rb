class DockerClean < Formula
  desc "Clean Docker containers, images, networks, and volumes"
  homepage "https://github.com/ZZROTDesign/docker-clean"
  url "https://github.com/ZZROTDesign/docker-clean/archive/v2.0.4.tar.gz"
  sha256 "4b636fd7391358b60c05b65ba7e89d27eaf8dd56cc516f3c786b59cadac52740"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e38bc9a6cf2fe9b1543817186dc28477f5df1fe25e0a4063efc60fef514248c6"
  end

  def install
    bin.install "docker-clean"
  end

  test do
    system "#{bin}/docker-clean", "--help"
  end
end
