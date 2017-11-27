class TorBrowser < Formula
  desc "Modified Firefox with privacy add-ons, encryption & advanced proxy"
  homepage "https://www.torproject.org/projects/torbrowser.html.en"
  url "https://www.torproject.org/dist/torbrowser/7.0.10/tor-browser-linux64-7.0.10_en-US.tar.xz"
  version "7.0.10"
  sha256 "10eebffe22594d336441ed59e5edc97ba1d296eb7d94bca3ff94ebfac2da3e34"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"start-tor-browser.desktop" => "tor-browser"
  end

  test do
    cd(libexec) do
      assert_equal "Launching './Browser/start-tor-browser --detach --verbose --version'...\nMozilla Firefox 52.5.0\n", shell_output("#{bin}/tor-browser --verbose --version 2>&1")
    end
  end
end
