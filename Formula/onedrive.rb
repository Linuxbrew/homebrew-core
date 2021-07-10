class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.4.12.tar.gz"
  sha256 "4f6aa46fc28e859b63c0a2c190f66c3286ec0bde3f54f77af0ddea6b62bba37a"

  depends_on "dmd" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on :linux
  depends_on "sqlite"

  patch do
    url "https://github.com/abraunegg/onedrive/commit/761cf3eb878fd370576329127055eec06b975672.patch?full_index=1"
    sha256 "9a892e5e6bed7695754d49f9561d59f22180db7340493ec7f167bee767b8c28e"
  end

  def install
    ENV["DC"] = "dmd"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash" => "onedrive"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
    fish_completion.install "contrib/completions/complete.fish" => "onedrive.fish"
  end

  test do
    system "#{bin}/onedrive", "--version"
  end
end
