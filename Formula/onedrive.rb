class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.3.13.tar.gz"
  sha256 "efa8f132a0dfe5faf1b24c4afaffe95954262bb4e48024198ac984df195f82ed"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f4aa18de24236b432a9148e200886210480e3588e365ec2a096a891b57ab01e" => :x86_64_linux
  end

  depends_on "dmd" => :build
  depends_on "pkg-config" => :build
  depends_on "curl-openssl"
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
