class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.8.3.34411.tar.gz"
  sha256 "03fec0b8a0fb7f6ba01a8ae6a65130744d231c54b8591151ea6a5d958effd178"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://cyberduck.io/changelog/"
    regex(/href=.*?Cyberduck[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d47eec2e2f7edcfb8aded3a3a55452393e792369dbde80d4d43d97002e60ee61"
    sha256 cellar: :any, big_sur:       "a268a727b5ae136482361928be799e3cd901e7de086a0186c73e7cd84fc69ef4"
    sha256 cellar: :any, catalina:      "def14b677c2ae117eec160826152f31d946a14da9275104aca1687a0dd091c2f"
    sha256 cellar: :any, mojave:        "7b07811f1867f234b3c22e98747ac759619161c5b6d52d220ea57bf8f151f0e4"
  end

  depends_on "ant" => :build
  depends_on "maven" => :build
  depends_on xcode: :build
  depends_on :macos

  def install
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}",
                  "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", "https://ftp.gnu.org/gnu/wget/wget-1.19.4.tar.gz", testpath/"test"
    assert_equal (testpath/"test").sha256, "93fb96b0f48a20ff5be0d9d9d3c4a986b469cb853131f9d5fe4cc9cecbc8b5b5"
  end
end
