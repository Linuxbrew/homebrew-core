class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.6.0.tar.gz"
  sha256 "c5502aeaa70ba4ca95c8fd5a5e19a9b6ca8e37f24878c9969b156ce4f9c30d93"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "270425824692bd5bdf84569139ec0ff874b6b1e742630caaff9e391f49e138d7" => :big_sur
    sha256 "d41e1b435b736381ccce4b89b064b03883c81b0cf3155e17f194a8b90dfce454" => :arm64_big_sur
    sha256 "cf908d84d60db5f00592e9a7df93b91d2da0628ee9de2b6d2cc06f6f8c2feda6" => :catalina
    sha256 "006e13cc8877c80227846fde77754cae52abcb2780a3fc6361581ea0c0d561b3" => :mojave
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
