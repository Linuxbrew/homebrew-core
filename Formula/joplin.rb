require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.163.tgz"
  sha256 "226a28c3180c6ab7fc721e04250dccd88fe32bc9f645d3ba7e663e89abf09103"
  revision 1

  bottle do
    sha256 "e7793913f82e802305a08749d56b793d90e80a6a9065c0d179954cf8479cfde6" => :catalina
    sha256 "7eb55cd103cabbb1d013109e5d3dd4cd30dc00fe8530454de2b35f31febf1d2d" => :mojave
    sha256 "6a0aee47b956af864f16f7714d0659b88218b3d2e7cda05af67b102d0deb44f8" => :high_sierra
    sha256 "fc24d1ad863a4fdea118ced98ef66675f3aa31060ac04d576efba0270fe437b7" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec),
                             "--sqlite=#{Formula["sqlite"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
