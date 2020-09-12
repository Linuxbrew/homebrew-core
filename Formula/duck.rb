class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.6.0.33437.tar.gz"
  sha256 "b724ee37fce1cf1d49c07f0d765ff2d233cb58a6b09c6d2c6ae0870061c157d2"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://cyberduck.io/changelog/"
    regex(/href=.*?Cyberduck[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "cf4a22c4d615cb9762d766deb6976c288d446eaac670e4991928f5e1648fa3b4" => :catalina
    sha256 "8ce4c07561ec7909fd0be36d118b0f24c97dc3d29176cc4f7f4152775dd2370c" => :mojave
    sha256 "56db96447ba14c145183ad58231bd3f3d680d5eb0fb10c3da23790f3656f2e6e" => :high_sierra
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
