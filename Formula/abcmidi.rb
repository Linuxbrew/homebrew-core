class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2020.07.14.zip"
  sha256 "09f2839f9ec171e5c8253998d510dbd16959e68f98b74fa8a18f22f4ffeab837"

  bottle do
    cellar :any_skip_relocation
    sha256 "038a5de5b8a58b280a88d00e3af6a55daf9373a3708226ce6cd1f2f2a00d9d10" => :catalina
    sha256 "b7f1c37bf1b9be09af91b3b061271e654f53261c1b204bfb2c795820bd4c26c7" => :mojave
    sha256 "693aaafa5b0d24c2594911bfb4993abbe0ba65fc9ad6c59450e5eb9e33f24b4b" => :high_sierra
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm_f "makefile"

    # Fix "Failed to execute: ./configure" issue
    chmod 0755, "./configure"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
