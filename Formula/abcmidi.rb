class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2020.05.06.zip"
  sha256 "69939ef6d331c0d920b3a7a2834b1fca6ba0e6da867b6f960b222c0b9861545f"

  bottle do
    cellar :any_skip_relocation
    sha256 "28aea01011ea911d821289153a81bd36c434623c53e69416a34938b597804be4" => :catalina
    sha256 "7f8698f1dbc1a731bc44840e87e0f2b3f7be77c29ea89a072991f6371befc8b9" => :mojave
    sha256 "23d64f40e97562114520ed51c32c514828bbcd96903b3db60317b2347dd02172" => :high_sierra
    sha256 "706cc7c955ad5c3a7a4e4da41b087bb2fb87e204858c805ff165562e89c51cdc" => :x86_64_linux
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm_f "makefile"

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
