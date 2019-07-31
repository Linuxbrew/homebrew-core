# modules: Build a bottle for Linuxbrew
class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.3.0/modules-4.3.0.tar.bz2"
  sha256 "3a33ab5ca9f43b12491896859bb812721c5dc4bd7500fce35a51a802760cec49"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9ade73ad63d8d66cbb15e65668ed365c97ca7e43c01c0888aeeda469a5860c" => :mojave
    sha256 "e7eb38927dd127c48712b2a8f97a0e63877c3b7c31a70ff3e928a97ff9d5051c" => :high_sierra
    sha256 "c7352c28ef997d528026f2f2a28263ae56ba7000bcded5b5809f45eb446597ea" => :sierra
  end

  unless OS.mac?
    depends_on "tcl-tk"
    depends_on "less"
  end

  def install
    tcl = OS.mac? ? "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].opt_lib
    with_tclsh = OS.mac? ? "" : "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    with_pager = OS.mac? ? "" : "--with-pager=#{Formula["less"].opt_bin}/less"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcl}
      #{with_tclsh}
      #{with_pager}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    To activate modules, add the following at the end of your .zshrc:
      source #{opt_prefix}/init/zsh
    You will also need to reload your .zshrc:
      source ~/.zshrc
  EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    if OS.mac?
      output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    else
      output = shell_output("sh -c '. #{prefix}/init/sh; module' 2>&1")
    end
    assert_match version.to_s, output
  end
end
