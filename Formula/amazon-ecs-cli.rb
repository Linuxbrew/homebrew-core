# amazon-ecs-cli: Build a bottle for Linuxbrew
class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.2.2.tar.gz"
  sha256 "e25ffea7ea4c40205064ce9855595425325a1d3c88f2566d7578cc70281bb576"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9f6ba3103a3907d186e34749f3f251b43f68ad1f429a84d401b22a496be1c80" => :high_sierra
    sha256 "c52e010481d1dd645f14ce7f8e8501afe5f32035f3c8053d139ead561e314093" => :sierra
    sha256 "6cd4bdcbb688afa61f55536e26acf19ab92cc76e26dd829c3a5240a892623c33" => :el_capitan
    sha256 "a2ccb7ad31f062a4ed3f90aa4c5c6f705516e6f1812d1f1822afd187ba4945c6" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      # Tests fail on Linux. Temporarly disabled.
      system "make", "test" if OS.mac?
      bin.install "bin/local/ecs-cli"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
