require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.149.tgz"
  sha256 "26b1c4b80db58148e934852016687ced1c617f1841afc9b1e5eea00e10e20c8e"
  revision 1

  bottle do
    sha256 "165fa445621934b879f92be8aa29ccac65aa70040530707ce87f8d8817b2244e" => :catalina
    sha256 "4b79c9769e29c18ac5a90132cd58837fefbcaa7624c3afc6bb47198bc58342be" => :mojave
    sha256 "46c9888420c58b95c653c362b389e4c8c996dc3cccb6f8dde46a000360488ff9" => :high_sierra
  end

  depends_on "node"
  uses_from_macos "python@2"
  depends_on "vips" unless OS.mac?

  def install
    # patch to support node 13, remove during next compatible upgrade
    inreplace "package.json", "\"sharp\": \"^0.22.1\",", "\"sharp\": \"^0.23.2\","
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
