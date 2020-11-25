class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  license "Apache-2.0"
  revision 1
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9a971099c0ab85804166dbf96b99653f37cc8095749df982d346ee397c8f9cd5" => :amd64_linux
    sha256 "9aa39804489c31c10f4975b06ad0527f7889f2909e5434b220635aea85137d85" => :i386_linux
    sha256 "9c2c3b36853b67fb0820c6085520a4e45a6d3116b47d4d8e8babf46b6a267a04" => :arm_linux
    sha256 "e0d490c98a5252e12a20560c39b8320cf567f4c980ee80f127f2dd02ecbb01e1" => :arm64_linux
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
    mkdir("$HOME/.jabba")
    cp("#{dir}/install.sh", "$HOME/.jabba/")
  end

  test do
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    system bin/"jabba", "install", "openjdk@1.14.0"
    jdk_path = shell_output("#{bin}/jabba which openjdk@1.14.0").strip
    assert_match 'openjdk version "14',
    shell_output("#{jdk_path}#{OS.mac? ? "/Contents/Home/" : "/"}bin/java -version 2>&1")
  end
end
