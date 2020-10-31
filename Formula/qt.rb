# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.15/5.15.1/single/qt-everywhere-src-5.15.1.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.1/single/qt-everywhere-src-5.15.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.1/single/qt-everywhere-src-5.15.1.tar.xz"
  sha256 "44da876057e21e1be42de31facd99be7d5f9f07893e1ea762359bcee0ef64ee9"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1 unless OS.mac?

  head "https://code.qt.io/qt/qt5.git", branch: "dev", shallow: false

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "98b58f82856c44dd6d675db01bcbbf05bf371c62d63be8c32b1a2facb17145bb" => :catalina
    sha256 "b9e96e6ae3d37a9d3c56369ab4dfa329361d83c2b632da53037feaf26d0362b5" => :mojave
    sha256 "75f2dda074131afb9423cff66d38f20815f61955b192a4834b169947a4ebf8e4" => :high_sierra
    sha256 "555a0e067b609970e4329ec94bd5b20f6aa9c30e426ebd564e5c7f4ee77d5af4" => :x86_64_linux
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on macos: :sierra if OS.mac?

  unless OS.mac?
    depends_on "at-spi2-core"
    depends_on "fontconfig"
    depends_on "glib"
    depends_on "gperf"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "libxkbcommon"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxcomposite"
    depends_on "libdrm"
    depends_on "linuxbrew/xorg/wayland"
    depends_on "linuxbrew/xorg/xcb-util"
    depends_on "linuxbrew/xorg/xcb-util-image"
    depends_on "linuxbrew/xorg/xcb-util-keysyms"
    depends_on "linuxbrew/xorg/xcb-util-renderutil"
    depends_on "linuxbrew/xorg/xcb-util-wm"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "python@3.8"
    depends_on "systemd"
    depends_on "zstd"
  end

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"

  # Fix build on Linux when the build system has AVX2
  # Patch submitted at https://codereview.qt-project.org/c/qt/qt3d/+/303993
  patch do
    url "https://codereview.qt-project.org/gitweb?p=qt/qt3d.git;a=patch;h=b456a7d47a36dc3429a5e7bac7665b12d257efea"
    sha256 "e47071f5feb6f24958b3670d83071502fe87243456b29fdc731c6eba677d9a59"
    directory "qt3d"
  end

  def install
    # Workaround for disk space issues on github actions
    # https://github.com/Homebrew/linuxbrew-core/pull/19595
    system "/home/linuxbrew/.linuxbrew/bin/brew", "cleanup", "--prune=0" if ENV["CI"]

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-system-zlib"
    elsif OS.linux?
      args << "-R#{lib}"
      # https://bugreports.qt.io/browse/QTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-qt-zlib"
      # https://bugreports.qt.io/browse/QTBUG-60163
      # https://codereview.qt-project.org/c/qt/qtwebengine/+/191880
      args += %w[-skip qtwebengine]
      args -= ["-proprietary-codecs"]
    end

    system "./configure", *args

    # Remove reference to shims directory
    inreplace "qtbase/mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkg-config"].opt_bin/"pkg-config"}"
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
