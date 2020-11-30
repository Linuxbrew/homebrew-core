class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.4.5.tar.gz"
  sha256 "1f1f5e1f2f37376b6d96bda2426552a94a8b195f545b4fb7f3668c4fe2e8f6a0"
  revision 1

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "dmd" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on :linux
  depends_on "sqlite"

  def install
    ENV["DC"] = "dmd"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
  end

  test do
    system "#{bin}/onedrive", "--version"
  end
end
