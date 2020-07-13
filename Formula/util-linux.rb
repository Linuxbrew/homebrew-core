class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.2.tar.xz"
  sha256 "21b7431e82f6bcd9441a01beeec3d57ed33ee948f8a5b41da577073c372eb58a"
  license "GPL-2.0"
  revision 1 unless OS.mac?

  bottle do
    sha256 "8f9f0592f1135621eb61133f986c9372e6fa718d4137dfdaa63f2c212d729564" => :catalina
    sha256 "10530ca9de44cb341b50114f3c740b58b7daaf030568662ac2a174feb1c25e49" => :mojave
    sha256 "458ece9b1190f761a6fc42bf66484eec1e67cafb5ef44d6ccd40ee9a0b05cc7c" => :high_sierra
    sha256 "1b15b7f9207ea4f5f7f93beaa391783ca0fcf78d6e40452b38880b2b845e2b87" => :x86_64_linux
  end

  keg_only "macOS provides the uuid.h header" if OS.mac?

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split(" ")
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
