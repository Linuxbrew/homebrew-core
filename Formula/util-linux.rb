class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.30/util-linux-2.30.1.tar.xz"
  sha256 "1be4363a91ac428c9e43fc04dc6d2c66a19ec1e36f1105bd4b481540be13b841"
  head "https://github.com/karelzak/util-linux.git"
  # tag "linuxbrew"

  bottle do
    sha256 "5b486d6909cec2d0f5571163b18d5c3241394c8e445417a9247aa02a9dc3639f" => :x86_64_linux # glibc 2.19
  end

  depends_on "ncurses" unless OS.mac?
  depends_on "linuxbrew/extra/linux-pam" => :optional

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      # Fix chgrp: changing group of 'wall': Operation not permitted
      "--disable-use-tty-group",
      # Conflicts with coreutils.
      "--disable-kill",
      # Conflicts with bsdmainutils
      "--disable-cal",
      "--disable-ul",
      # Do not install systemd files
      "--without-systemd",
      "--with-bashcompletiondir=#{bash_completion}",
    ]
    args += %w[--disable-chfn-chsh --disable-login --disable-su --disable-runuser] if build.without? "linux-pam"
    system "./configure", *args
    system "make", "install"

    # Conflicts with bsdmainutils and cannot be manually disabled
    conflicts = %w[
      col*
      hexdump*
      look*
    ]
    conflicts.each do |conflict|
      rm_f Dir.glob("{#{bin},#{man1}}/#{conflict}")
    end

    # conflicts with bash-completion
    ["mount", "rtcwake"].each { |conflict| rm bash_completion/conflict }
  end

  def caveats; <<-EOS.undent
    Some commands were moved to the bsdmainutils formula.
    You may wish to install it as well.
    EOS
  end

  test do
    (testpath/"tmpfile").write("temp")
    system bin/"rename", "tmp", "temp", testpath/"tmpfile"
    assert File.exist?(testpath/"tempfile")
  end
end
