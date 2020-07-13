class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag      => "v1.10.2",
      :revision => "9ec2c2baff0894d2b998254d52389d253d1dd386"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "8623d7ac5d3574354f3be6ef61c5cbffd85973012fc3aa6eb120101232da8e0e" => :catalina
    sha256 "109cb8b7fe97cc03aa85191d2fb2fc8e138c06924421ec036c53b12e80339c8b" => :mojave
    sha256 "9fb3845730765b47e238267395ad55e030c4634c291fc68fb9f008119202fada" => :high_sierra
    sha256 "b8530ae3b19dcae5b978124cb8b5d7f0e074f4a95b3bb85ec6351540b660393e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glew"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "snappy"

  def install
    args = std_cmake_args
    # Use brewed FFmpeg rather than precompiled binaries in the repo
    args << "-DUSE_SYSTEM_FFMPEG=ON"

    # fix missing include for zipconf.h
    ENV.append_to_cflags "-I#{Formula["libzip"].opt_prefix}/lib/libzip/include"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      if OS.mac?
        prefix.install "PPSSPPSDL.app"
        bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
        mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"
      else
        bin.install "PPSSPPSDL" => "ppsspp"
      end
    end
  end
end
