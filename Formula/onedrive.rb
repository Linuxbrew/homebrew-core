class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.3.8.tar.gz"
  sha256 "4268f54835592ef8d2d42bd086877bb403da3dbdda485175893bf73b3a561028"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fb98dfcff6c224d9bf38606bd861bad5a6ab12e95ff039da7f8ddc928310c00" => :x86_64_linux
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
