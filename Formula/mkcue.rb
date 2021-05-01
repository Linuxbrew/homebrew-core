class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/sid/mkcue"
  url "https://deb.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"
  license "LGPL-2.1"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52943029895b1e24197f114414788ca21b60e7fa870e2950ab23d6f98cad2e2f"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]

    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      on_macos do
        system "#{bin}/mkcue", "test"
      end
      on_linux do
        assert_match "Cannot read table of contents", shell_output("#{bin}/mkcue test 2>&1", 2)
      end
    end
  end
end
