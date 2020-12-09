class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-7.7.2.33862.tar.gz"
  sha256 "f18b523e25279fcbbc38c8bc018894cbfc2ba3dd644468356237b7c9302e62f5"
  license "GPL-3.0-only"
  head "https://svn.cyberduck.io/trunk/"

  livecheck do
    url "https://cyberduck.io/changelog/"
    regex(/href=.*?Cyberduck[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    cellar :any
    sha256 "f7ec445fb558b0e2e498bede14bb2b01732ddae3a904d98a96bbd26880860c7b" => :big_sur
    sha256 "8da0b072d2f6aa3b1f6b9c1b2159a596a31c6e0ea431f0c49d89989340669e33" => :catalina
    sha256 "8cabf0aec9b0e33fd4be3a4644cd7e354ed41fade88a7f8a8d1a6dbfad799884" => :mojave
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
