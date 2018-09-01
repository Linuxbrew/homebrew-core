class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"
  revision OS.mac? ? 1 : 2

  bottle do
    cellar :any
    sha256 "977cf2845acc9cdcbcf1b7e92d9c0af0066c5d0cc17df307a123c13180a64e62" => :mojave
    sha256 "d551dad77ab8c533bab98d5bd91291db1f296564336d59d600f0ce75496a9d08" => :high_sierra
    sha256 "aeef9c88dd7ea82ac3f71b6f3793b2316b76ee59a8e01cc56f6316efa4e1346c" => :sierra
    sha256 "f3040a39ad4ffb9eabd9446843dfc3b66df01b3264c875dc68e7339636830357" => :el_capitan
  end

  depends_on "ncurses" unless OS.mac?
  depends_on "linuxbrew/extra/linux-pam" => :optional

  conflicts_with "rename", :because => "both install `rename` binaries"

  def install
    args = [
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
    end if OS.mac?

    # these conflict with bash-completion-1.3
    %w[chsh mount rfkill rtcwake].each do |prog|
      rm_f bash_completion/prog
    end unless OS.mac?

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
        # these conflict with bash-completion on Linux
        next if !OS.mac? && %w[chsh mount rfkill rtcwake].include?(prog.basename.to_s)
        bash_completion.install prog
      end
    end
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    group = OS.mac? ? "wheel" : "root"
    assert_equal ["f: /usr", "Drwxr-xr-x root #{group} /", "drwxr-xr-x root #{group} usr"], out
  end
end
