class Pgmig < Formula
  desc "Standalone PostgreSQL Migration Runner"
  homepage "https://github.com/leafclick/pgmig/"
  license "Apache-2.0"
  bottle :unneeded

  if OS.linux?
    url "https://github.com/leafclick/pgmig/releases/download/v0.5.0/pgmig-0.5.0-linux-amd64.zip"
    sha256 "eb677803e72c3c1d1f46eddf81ba52e59ab7c5fe4ec702b1809a11237b614db9"
  else
    url "https://github.com/leafclick/pgmig/releases/download/v0.5.0/pgmig-0.5.0-macos-amd64.zip"
    sha256 "87d648ce4515067ed8974cc9c7aacf658f7418ad15828dd2b408c325e377c2a8"
  end

  def install
    bin.install "pgmig"
  end

  test do
    assert_match "pgmig 0.5.0", shell_output("#{bin}/pgmig -V 2>&1")
  end
end
