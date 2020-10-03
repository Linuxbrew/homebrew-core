class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.2.0.tar.xz"
  sha256 "63f0359575d558ef98dd78adffc0df4c66b76964ebf603b778b7004964191d30"
  license "MIT"
  revision 1 unless OS.mac?
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "80f2a41eb9de16114eb1ca1d9635d5ca2d22b9651bbdafb621b3b3ff35998d00" => :catalina
    sha256 "3b5251d783c51d20fe2f72067d8b060267d522e285b2eb67f215a737396ec6c1" => :mojave
    sha256 "3e7f48cbb9e932c7be02a100db4986ddc2fd3780a199be668f15e049b021666b" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "freeglut" => :test if OS.mac?
  depends_on "expat"
  depends_on "gettext"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm"
    depends_on "lm-sensors"
    depends_on "libx11"
    depends_on "libelf"
    depends_on "libxcb"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxvmc"
    depends_on "libxxf86vm"
    depends_on "linuxbrew/xorg/libdrm"
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

  resource "gears.c" do
    url "https://www.opengl.org/archives/resources/code/samples/glut_examples/mesademos/gears.c"
    sha256 "7df9d8cda1af9d0a1f64cc028df7556705d98471fdf3d0830282d4dcfb7a78cc"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    venv_root = libexec/"venv"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      args = %w[
        -Db_ndebug=true
      ]

      if OS.mac?
        args << "-Dplatforms=surfaceless"
        args << "-Dglx=disabled"
      else
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
    if OS.mac?
      flags = %W[
        -framework OpenGL
        -I#{Formula["freeglut"].opt_include}
        -L#{Formula["freeglut"].opt_lib}
        -lglut
      ]
      system ENV.cc, "#{pkgshare}/gears.c", "-o", "gears", *flags
    else
      output = shell_output("ldd #{lib}/libGL.so").chomp
      libs = %w[
        libxcb-dri3.so.0
        libxcb-present.so.0
        libxcb-sync.so.1
        libxshmfence.so.1
        libglapi.so.0
        libXext.so.6
        libXdamage.so.1
        libXfixes.so.3
        libX11-xcb.so.1
        libX11.so.6
        libxcb-glx.so.0
        libxcb-dri2.so.0
        libxcb.so.1
        libXxf86vm.so.1
        libdrm.so.2
        libXau.so.6
        libXdmcp.so.6
        libexpat.so.1
      ]

      libs.each do |lib|
        assert_match lib, output
      end
    end
  end
end
