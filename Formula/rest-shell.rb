class RestShell < Formula
  desc "Shell to work with Spring HATEOAS-compliant REST resources"
  homepage "https://github.com/spring-projects/rest-shell"
  url "http://download.gopivotal.com/rest-shell/1.2.1/rest-shell-1.2.1.RELEASE.tar.gz"
  # Specify version explicitly at version bump:
  # version "1.2.1"
  sha256 "0ecfa67d005cc0d51e7a3a26c4dacc53aa12012f0e757332a2fa40c5e780c2d6"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7e51b5c4e3d3b11db444b9309f7e218474b1150dbc4042af3a40b7912055767c" # linuxbrew-core
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    (bin/"rest-shell").write_env_script libexec/"bin/rest-shell", Language::Java.overridable_java_home_env("11")
  end

  test do
    system "#{bin}/rest-shell"
  end
end
