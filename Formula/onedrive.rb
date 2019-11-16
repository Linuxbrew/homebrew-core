class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.3.8.tar.gz"
  sha256 "4268f54835592ef8d2d42bd086877bb403da3dbdda485175893bf73b3a561028"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "690d7e3090cc3ae0a1f5b1dab1bae31755c152a6d58e7cb493db734afc41c7aa" => :x86_64_linux
  end

  depends_on "ldc" => :build
  depends_on "pkg-config" => :build
  depends_on "curl-openssl"
  depends_on "sqlite"

  def install
    ENV["DC"] = "ldc2"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
  end

  test do
    system "#{bin}/onedrive", "--version"
  end
end
