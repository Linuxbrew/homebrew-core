class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system."
  homepage "http://www.alsa-project.org/"
  url "ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.2.tar.bz2"
  sha256 "d38dacd9892b06b8bff04923c380b38fb2e379ee5538935ff37e45b395d861d6"
  # tag "linuxbrew"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <alsa/asoundlib.h>
    int main(void)
    {
        snd_ctl_card_info_t *info;
        snd_ctl_card_info_alloca(&info);
        return 0;
    }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end
