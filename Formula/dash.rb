class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.4.tar.gz"
  sha256 "4e15b7ba5363bcc2a443549910cdc15b5ad601df8196b5f294c712eff037e08d"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c395d7a9947b74cb4dbe37380c47327702d93f40c3379652fdc8172824299fa6"
    sha256 cellar: :any_skip_relocation, big_sur:       "11cc317053e0f398a3aa14f2dca06e5bc45b215859953e45153d2f4af7853435"
    sha256 cellar: :any_skip_relocation, catalina:      "a4fd41a1b67977e509ae2612c6d57914d010c4352b606c0a5b49e7c81af8b6e7"
    sha256 cellar: :any_skip_relocation, mojave:        "7c2387fa98bdb02ae966b055948baf6b911c494f54e996087a5e4c42f173f8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371787f2430df1c94532e4a167e347902e88a1f2efbfa25c3dfa6cd8423af56e" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
