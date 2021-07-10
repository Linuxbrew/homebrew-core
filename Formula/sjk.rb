class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.18/sjk-plus-0.18.jar"
  sha256 "583284174dde91c32acdef01550d376b2e15be8573e5d99007651451f5bc8854"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fbef52d37081d50d8822e1b3582d5311c645c5c8c47c613336b298c78cb8ff81" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec/"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
