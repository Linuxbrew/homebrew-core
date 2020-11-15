class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.2.2.tar.xz"
  sha256 "1f93eb1090cf71490cd0e204e04f8427a82b6ed534b7f49ca50cea7dcc89b861"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "701d9396f85b7d3f77ab84a6028c29a4ac94afe2deb0802da859925c1b89fd74" => :big_sur
    sha256 "29cd2a659ce5ddc74562aed58858de062370d0c0926b567f8a970a01df3c078a" => :catalina
    sha256 "d595201ce00761430d745b6d7e7248e150567fc760d8f8b1d0c1d68ae05784c2" => :mojave
    sha256 "bd279b58b20c25a4e8c76e30c43e59c02b7cc7199bb1372fb7e66c83dca3531d" => :high_sierra
    sha256 "f43ec1abbd9a205c9d4fa05a7e6fb00bdd6237124c492f430a6387a467a03d4e" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "expat"
  depends_on "gettext"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm"
    depends_on "lm-sensors"
    depends_on "libelf"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxvmc"
    depends_on "libxxf86vm"
    depends_on "libdrm"
    depends_on "linuxbrew/xorg/libomxil-bellagio"
    depends_on "linuxbrew/xorg/libva-internal"
    depends_on "linuxbrew/xorg/libvdpau"
    depends_on "linuxbrew/xorg/wayland"
    depends_on "linuxbrew/xorg/wayland-protocols"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
  end

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/xdemos/glxgears.c"
    sha256 "3873db84d708b5d8b3cac39270926ba46d812c2f6362da8e6cd0a1bff6628ae6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/util/gl_wrap.h"
    sha256 "c727b2341d81c2a1b8a0b31e46d24f9702a1ec55c8be3f455ddc8d72120ada72"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    venv_root = libexec/"venv"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      args = %w[
        -Db_ndebug=true
      ]

      unless OS.mac?
        args << "-Dplatforms=x11,wayland,drm,surfaceless"
        args << "-Dglx=auto"
        args << "-Ddri3=true"
        args << "-Ddri-drivers=auto"
        args << "-Dgallium-drivers=auto"
        args << "-Degl=true"
        args << "-Dgbm=true"
        args << "-Dopengl=true"
        args << "-Dgles1=true"
        args << "-Dgles2=true"
        args << "-Dxvmc=true"
        args << "-Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,xvmc,lima"
      end

      system "meson", *std_meson_args, "..", *args
      system "ninja"
      system "ninja", "install"
    end

    unless OS.mac?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["libx11"].lib}
      -L#{Formula["libxext"].lib}
      -lGL
      -lX11
      -lXext
      -lm
    ]
    system ENV.cc, "glxgears.c", "-o", "gears", *flags
  end
end
