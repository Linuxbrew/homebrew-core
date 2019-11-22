# sops: Build a bottle for Linux
class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.5.0.tar.gz"
  sha256 "a9c257dc5ddaab736dce08b8c5b1f00e6ca1e3171909b6d7385689044ebe759b"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c520c5ba4d9f6941e2371f25c811136352b7eafdd1613275e30b2f62462b3fa8" => :catalina
    sha256 "3f912b8ecfa30d66b5803e0dfdff01aa550dbd1e2bd08cd315a4be4216375d57" => :mojave
    sha256 "c2ce8bb370f5b3888de5696707c69627178aabdc6063ff35cce075c3df502a51" => :high_sierra
  end

  depends_on "go@1.12" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/mozilla/sops"
    dir.install buildpath.children

    cd dir do
      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
