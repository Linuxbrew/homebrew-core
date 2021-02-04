class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
      tag:      "v0.9.2",
      revision: "0872cc18d44a96ed9f59202ac95c556f7e7919a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c03616976f43d70fc9f298f3eb7bb7b4f3bfad58611326424b6340341bb3098"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c24a8bf42cae151e305b3ca83c8ef6c59acb87d1db58023e1cf10a5a3aca8d9"
    sha256 cellar: :any_skip_relocation, catalina:      "bb8417748b9d7e9199951eccdeb6892e468721480b5b639e94bee7541cfdf25c"
    sha256 cellar: :any_skip_relocation, mojave:        "12d537965d7d988136ff5aa24f002dbf8ce1a161f30e89167d7c1262ac1346c8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8ad8419f3ac59cb8b3e1627c0c329d773a1c6583e10693441a49a5f66c1efc71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0c36c28347a8a8311c625d51f6511634a40ed0dc7ed643bc00452a11887e18"
  end

  depends_on "go" => :build
  depends_on "gpgme" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gpgme" => :build
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"dive"
    prefix.install_metafiles
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
