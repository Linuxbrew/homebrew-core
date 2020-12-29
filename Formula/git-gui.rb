class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.0.tar.xz"
  sha256 "55735021109565721af805af382c45cce73c3cfaa59daad22443d1477d334d19"
  license "GPL-2.0"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "6daa1a3d93f88e183dd97a9dfe564a0e73daabeb3f6b55b92c69c02b9a1bce3b" => :big_sur
    sha256 "a88e400fae60a6415a45299f4a979b8539c06b990e66d3c5897f796d5fe12420" => :arm64_big_sur
    sha256 "d23a4f19ee1235aca94ba49c9b3d04290df910bacb991a71ea9dfcd4d7ed4453" => :catalina
    sha256 "5983f88520e038b1dbe555d8bf09490cc8b1dc71961b57e31d1e46f684f9f0cf" => :mojave
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
