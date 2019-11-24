class Singularity < Formula
  desc "Application containers for Linux"
  homepage "https://www.sylabs.io/singularity/"
  url "https://github.com/sylabs/singularity/releases/download/v3.5.0/singularity-3.5.0.tar.gz"
  sha256 "849c699eb3569c1b9e4e0824223ea6c0fea8b0805b33ddd3400b7c795d07809e"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "go" => :build
  depends_on "openssl@1.1" => :build
  depends_on "libarchive"
  depends_on "pkg-config"
  depends_on "squashfs"
  depends_on "util-linux" # for libuuid

  def install
    system "./mconfig", "--prefix=#{prefix}"
    cd "./builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/singularity --help")
  end
end
