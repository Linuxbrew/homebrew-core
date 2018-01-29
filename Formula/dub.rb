class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.1.tar.gz"
  sha256 "baa8c533f59d83f74e89c06f5ec7e52daf3becb227c7177a9eeab7159ba86dbc"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  devel do
    url "https://github.com/dlang/dub/archive/v1.6.0-beta.2.tar.gz"
    sha256 "da1877c7c39a4905bca78083784733bfae59d60c7b665169d87fe2d81651b38f"
  end

  bottle do
    sha256 "24df5fff78cc739476e0246a114e41e3a4d65dc357b065e73c6186b77501f47a" => :x86_64_linux
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build
  depends_on "curl" unless OS.mac?

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
