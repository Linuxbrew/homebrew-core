class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.0/modules-4.5.0.tar.bz2"
  sha256 "9f2a12bf2f32ff69148117bb154d17c3e6b9b816c4907fef7127d65ce60f1c73"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc8e1339ea1fa2265c680c0a29e96cb9b3dbdcc7ce789e3708989ed1ccfd3af5" => :catalina
    sha256 "6ac40d686f229d8374e185a1487551a84c6fba4a71c37d319cbd5e44051ed869" => :mojave
    sha256 "af783a47bae2302f93142b1980ba3d05b49583c28b0ddf71dcc6dbf9c2705cd5" => :high_sierra
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

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = if OS.mac?
      shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    else
      shell_output("sh -c '. #{prefix}/init/sh; module' 2>&1")
    end
    assert_match version.to_s, output
  end
end
