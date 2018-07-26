# util-linux: Build a bottle for Linuxbrew
class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"

  bottle do
    cellar :any
    sha256 "dcfc28966d982c03bcbdad6fa531e27998446e3000b1bf39c73d7bfc7ebb423e" => :high_sierra
    sha256 "c220f5314101fa69fc67a696b6f21d68b49489a91778ae873e4163c322fa3185" => :sierra
    sha256 "f2ead84d7ee46a582a800ab4cde3dfeb17b5cd6e615a43799cb7c653ac70512d" => :el_capitan
  end

  depends_on "ncurses" unless OS.mac?
  depends_on "linuxbrew/extra/linux-pam" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    if OS.mac?
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-libuuid" # conflicts with ossp-uuid
      args << "--disable-libsmartcols" # macOS already ships 'column'
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--disable-cal" # Conflicts with bsdmainutils
      args << "--without-systemd" # Do not install systemd files
      args << "--with-bashcompletiondir=#{bash_completion}"
    end

    args += %w[
      --disable-chfn-chsh
      --disable-login
      --disable-su
      --disable-runuser
      --disable-makeinstall-chown
      --disable-makeinstall-setuid
    ] if build.without? "linux-pam"

    system "./configure", *args
    system "make", "install"

    # Remove binaries already shipped by macOS
    %w[cal col colcrt colrm getopt hexdump logger nologin look mesg more renice rev ul whereis].each do |prog|
      rm_f bin/prog
      rm_f sbin/prog
      rm_f man1/"#{prog}.1"
      rm_f man8/"#{prog}.8"
      rm_f share/"bash-completion"/"completions"/prog
    end if OS.mac?

    # conflicts with bash-completion
    ["mount", "rtcwake"].each { |conflict| rm bash_completion/conflict } unless OS.mac?
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    group = OS.mac? ? "wheel" : "root"
    assert_equal ["f: /usr", "Drwxr-xr-x root #{group} /", "drwxr-xr-x root #{group} usr"], out
  end
end
