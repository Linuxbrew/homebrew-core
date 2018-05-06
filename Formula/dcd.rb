# dcd: Build a bottle for Linuxbrew
class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.5",
      :revision => "723a3ee113941742b310010d221b9dfb38206e42"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    sha256 "44de7ea16523d095e9beaafc89acb4caf9f91e4cfa2baadab1faad9d70cd7e30" => :x86_64_linux
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    begin
      # spawn a server, using a non-default port to avoid
      # clashes with pre-existing dcd-server instances
      server = fork do
        exec "#{bin}/dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "#{bin}/dcd-client", "-q", "-p9167"
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
