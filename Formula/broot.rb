# broot: Build a bottle for Linux
class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.10.1.tar.gz"
  sha256 "1a05e66f8e65fa54bcab89b58cbc2569d8bf8800bcda082c5f91e3087028d57c"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c4afaa643707b3b44263229d80a9a9d31ab3c3e8871a16f2886c2aa6636c0ed" => :catalina
    sha256 "a2de879e9ec8b6eed08ecc3dcbb5801d1bed5aecaf903eff2dfa664f9b3baeb5" => :mojave
    sha256 "22edc6ade4f4b63b31988decc8064322e2ee75f1b38a1a0e24ec3700f1d6f4f0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if ENV["CI"]

    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
