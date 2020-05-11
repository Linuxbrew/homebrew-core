class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz"
  sha256 "d93f351d50af05a75fe6681085670c786d9504a5da2608e481c47cf5e1486db9"

  bottle do
    cellar :any
    sha256 "f26bd0c3f5696350dcaf229d0fadaf6ab677c0ebbb550fc499ca0a37da59ab55" => :catalina
    sha256 "e9995ca765078be9cfdef4f1b6a628bcded0e96e36649e084a7f5480d165547a" => :mojave
    sha256 "7a04ece8143c0647be18bb14c160a984a5a9f855fa2ee888d21fc19374790ee5" => :high_sierra
    sha256 "661641854a9bc8b9c45e868901f7ec0a480ceecbf430d4f212082256e85c27ce" => :x86_64_linux
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-utf8proc
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
