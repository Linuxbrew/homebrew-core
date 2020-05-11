class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.05.tar.gz"
  sha256 "62e68c61970552f27f0bc4943bf92af5f4b9ae2a30ed4fa70784e1f7056c6625"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "4bee9d3801955f6b6d345b5dced23643122a80ec071e47288f2f52a5c4254877" => :catalina
    sha256 "e1d7d623732d27007d918936d219ca2ed9feb852300ed55df200c90b6ed47081" => :mojave
    sha256 "383efd54c5c1e61e13fab424d20f95dba7d4464862187e830f63978f9b7391a5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      FAudio is built without FFmpeg support for decoding xWMA resources.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfaudio", "-o", "test"
    system "./test"
  end
end
