class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.tar.xz"
  sha256 "6c7397abc764e32e8159c2e96042874a190303e77adceb4ac5bd502a272a4734"
  revision 1 unless OS.mac?

  bottle do
    cellar :any
    sha256 "8ff96bb1e4e04a8df26e0d062e855e0a83f4f6afe437c0fecca2ba0b891ac3e5" => :high_sierra
    sha256 "353016648e93cdaf7e9d277c0e7e26b3c681b19ccc6f87faa79996100de0925d" => :sierra
    sha256 "7d29b310f3bf5228b702031923ab8877ddaadaf46120ccf577d8b5ee9ca77e00" => :el_capitan
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
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    group = OS.mac? ? "wheel" : "root"
    assert_equal ["f: /usr", "Drwxr-xr-x root #{group} /", "drwxr-xr-x root #{group} usr"], out
  end
end
