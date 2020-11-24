class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "37336531b4b275cd6b29ebc67240db8e5de9d468fcebe91d8cb35f33e9a2e891"
  license "Apache-2.0"
  revision 1
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "95379695228c4f280886748df49bd54ad9075b36a18cc4371edb069e9c92e7d2" => :amd64_linux
    sha256 "f8f2aa2900431e37e3907f240cd7707598d1e2862c1b30e173749810005877f0" => :i386_linux
    sha256 "8b3662c33b2d338850a775727df76f96c47ca636362c498df6bbde270cc8e83a" => :arm_linux
    sha256 "2fbde40e00bade78a0b47eb3d2091f3519bfcb62ea03f4dee7853f63838a6385" => :arm64_linux
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/shyiko/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "glide", "install"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
    ENV["JABBA_HOME"] = "$HOME/.jabba"
  end

  test do
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    system bin/"jabba", "install", "openjdk@1.14.0"
    jdk_path = shell_output("#{bin}/jabba which openjdk@1.14.0").strip
    assert_match 'openjdk version "14',
    shell_output("#{jdk_path}#{OS.mac? ? "/Contents/Home/" : "/"}bin/java -version 2>&1")
    assert_match "/home/linuxbrew/.linuxbrew/bin/jabba", shell_output("which jabba")
  end
end
