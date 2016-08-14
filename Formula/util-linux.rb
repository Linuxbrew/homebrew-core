class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.27/util-linux-2.27.1.tar.xz"
  sha256 "0a818fcdede99aec43ffe6ca5b5388bff80d162f2f7bd4541dca94fecb87a290"
  revision 1
  head "https://github.com/karelzak/util-linux.git"
  # tag "linuxbrew"

  bottle do
    sha256 "e2a6b0ec0f81341af1033eaf6756e102c4bd39f31cce374c61d18272240c14a8" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      # Fix chgrp: changing group of 'wall': Operation not permitted
      "--disable-use-tty-group",
      # Conflicts with coreutils.
      "--disable-kill",
      # Conflicts with bsdmainutils
      "--disable-cal",
      "--disable-ul"
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
