class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.12.tar.gz"
  sha256 "d5a1656ec79cd2878dddabc07d7f7848c11844595c76033aed929b10d922c009"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "af1c6af27b35bd27494967153e35e341a83c7b7714454978ba952e9f486ff0ef" => :big_sur
    sha256 "e81004eda7a9d552bb1c54ee5cc5569838f4ca42953e4fb06866d541bc80df1f" => :catalina
    sha256 "cf3f846bef2b61e366f5cd0e4acc51cc0faa22f69a5af232fb40a710ba0926a5" => :mojave
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
