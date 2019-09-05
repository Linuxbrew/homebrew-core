class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.2.0.tar.gz"
  sha256 "5bce8cdb33a6580ff15214322bc66945c0b4d93375056865ad30e0415fece3de"
  revision 1
  head "https://github.com/nushell/nushell.git"

  depends_on "openssl@1.1"

  # Nu requires features from Rust 1.39 to build, so we can't use Homebrew's
  # Rust; picking a known-good Rust nightly release to use instead.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-09-05/rust-nightly-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "cbc6b9c924a7a16977899116a6789f171a15ea526646c59739df5fee7db00b82"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
