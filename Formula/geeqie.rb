class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v1.6/geeqie-1.6.tar.xz"
  sha256 "48f8a4474454d182353100e43878754b76227f3b8f30cfc258afc9d90a4e1920"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  test do
    system "#{bin}/geeqie", "--version"
  end
end
