class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"

  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.xz"
  sha256 "743f9d0c7252b6db246b659c1e1ce0bd45d8d4508b4dfa427bbb4a3e9b9f62b5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "4378cde04082e8ae81a32a02c329989f10a7b582354d248e81f5958d4a5cf150" => :mojave
    sha256 "618e77696340f47cda39e0f80dfdc9ddaf18462ee11b536139689c8dc1381b5c" => :high_sierra
    sha256 "569009c8d2f16d8ebaae5f56a8e6cf528e593f4c9e0ad3f32cf244fb6ddc8e65" => :sierra
    sha256 "f4fa70b203e1c3179c4045e8e7fc3d20e326cf68d7af929a8fd7cf06f7d84ae4" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

  keg_only "macOS provides the uuid.h header" if OS.mac?

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
      args << "--enable-libuuid" # conflicts with ossp-uuid
      args << "--disable-libsmartcols" # macOS already ships 'column'
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--disable-cal" # Conflicts with bsdmainutils
      args << "--without-systemd" # Do not install systemd files
      args << "--with-bashcompletiondir=#{bash_completion}"
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system "./configure", *args
    system "make", "install"

    if OS.mac?
      # Remove binaries already shipped by macOS
      %w[cal col colcrt colrm getopt hexdump logger nologin look mesg more renice rev ul whereis].each do |prog|
        rm_f bin/prog
        rm_f sbin/prog
        rm_f man1/"#{prog}.1"
        rm_f man8/"#{prog}.8"
      end
    else
      # these conflict with bash-completion-1.3
      %w[chsh mount rfkill rtcwake].each do |prog|
        rm_f bash_completion/prog
      end
    end

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
