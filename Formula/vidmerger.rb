class Vidmerger < Formula
  desc "Wrapper around ffmpeg which simlifies merging multiple videos 🎞"
  homepage "https://github.com/TGotwig/vidmerger"
  url "https://github.com/TGotwig/vidmerger/releases/download/v0.1.2/vidmerger-linux.tar.gz"
  sha256 "cbfd214cbe25dfd1cb865159d7cc69b9a857cfc3eaea72bf8391244711ab6377"

  def install
    bin.install "vidmerger"
  end

  test do
    assert true
  end
end
