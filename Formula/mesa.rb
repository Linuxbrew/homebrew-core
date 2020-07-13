class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-20.1.3.tar.xz"
  sha256 "9872b8d46bee822177ffbe4292addff7bdb84cefc1fe776b8e6b2881a8362bf1"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    sha256 "0ca7669cebc82d5b59c9a41d1f9b5ebc9e07215e9297b7f7bad32f92182e920e" => :catalina
    sha256 "2e70646a569df862685e6daabb723a83dae64b59d0ee2e26441c70f69948fdc5" => :mojave
    sha256 "6827b0ade68f0cffc757741b9a9c735a76a357fe42a1231510d9bf6f284fe12d" => :high_sierra
    sha256 "6ba73ab55e4ee1d3c0df26d05a73a447f12f0dbd06fd0a0ab16617dd36d3655f" => :x86_64_linux
  end

  depends_on "meson-internal" => :build
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

  unless OS.mac?
    depends_on "llvm"
    depends_on "libelf"
    depends_on "linuxbrew/xorg/libdrm"
    depends_on "linuxbrew/xorg/libomxil-bellagio"
    depends_on "linuxbrew/xorg/libva-internal"
    depends_on "linuxbrew/xorg/libvdpau"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxcb"
    depends_on "linuxbrew/xorg/libxdamage"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxfixes"
    depends_on "linuxbrew/xorg/libxrandr"
    depends_on "linuxbrew/xorg/libxshmfence"
    depends_on "linuxbrew/xorg/libxv"
    depends_on "linuxbrew/xorg/libxvmc"
    depends_on "linuxbrew/xorg/libxxf86vm"
    depends_on "linuxbrew/xorg/wayland"
    depends_on "linuxbrew/xorg/wayland-protocols"
    depends_on "lm-sensors"
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
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system python3, *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      args = %w[
        -Dbuildtype=plain
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
