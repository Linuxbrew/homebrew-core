class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # Note: Please keep these values in sync with git.rb when updating.
  url "https://www.kernel.org/pub/software/scm/git/git-2.26.2.tar.xz"
  sha256 "6d65132471df9e531807cb2746f8be317e22a343b9385bbe11c9ce7f0d2fc848"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "272b5e5ab0d3f511f640c743053ed8f78bc291e011fd94fa3b500f1e235aefe7" => :catalina
    sha256 "272b5e5ab0d3f511f640c743053ed8f78bc291e011fd94fa3b500f1e235aefe7" => :mojave
    sha256 "272b5e5ab0d3f511f640c743053ed8f78bc291e011fd94fa3b500f1e235aefe7" => :high_sierra
    sha256 "2f5aeff483b0161cbc05e5e6f7ab59f718ea13430e0a7cd6a37942b980df13a1" => :x86_64_linux
  end

  depends_on "tcl-tk"

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end
