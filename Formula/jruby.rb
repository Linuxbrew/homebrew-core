class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.2.19.0/jruby-dist-9.2.19.0-bin.tar.gz"
  sha256 "1f74885a2d3fa589fcbeb292a39facf7f86be3eac1ab015e32c65d32acf3f3bf"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e0182e32a400fc7f6e5f18c897c4e8f9ca0f9a7013cbbf4ba07a975eab0ab4e8"
    sha256 cellar: :any,                 big_sur:       "74486e1c636a83f12ee42b200b1ffb44a8205ce4962616a212bc270223200093"
    sha256 cellar: :any,                 catalina:      "74486e1c636a83f12ee42b200b1ffb44a8205ce4962616a212bc270223200093"
    sha256 cellar: :any,                 mojave:        "74486e1c636a83f12ee42b200b1ffb44a8205ce4962616a212bc270223200093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa5d9746cbf594f7a69dab6536ce2786501504c6431930c5e7b18e9cf60b4cc"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri testrb].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
