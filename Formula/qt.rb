# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.14/5.14.2/single/qt-everywhere-src-5.14.2.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.14/5.14.2/single/qt-everywhere-src-5.14.2.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.14/5.14.2/single/qt-everywhere-src-5.14.2.tar.xz"
  sha256 "c6fcd53c744df89e7d3223c02838a33309bd1c291fcb6f9341505fe99f7f19fa"

  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  bottle do
    cellar :any
    sha256 "235bbe918f05509380ba870b24a84e14cbac044b56ade7b824408ad11963de41" => :catalina
    sha256 "356f2d8914429724dc0b98ab194b3c32417870008650342a21ddbb26c130743d" => :mojave
    sha256 "78f577a236c2eee17e371ae5efe951b80e01f6e2a491b6922442b71e0a2cf3e6" => :high_sierra
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build if OS.mac?
  depends_on :macos => :sierra if OS.mac?

  unless OS.mac?
    depends_on "fontconfig"
    depends_on "glib"
    depends_on "gperf"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "libxkbcommon"
    depends_on "linuxbrew/xorg/libdrm"
    depends_on "linuxbrew/xorg/libice"
    depends_on "linuxbrew/xorg/libsm"
    depends_on "linuxbrew/xorg/libxcomposite"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/wayland"
    depends_on "linuxbrew/xorg/xcb-util"
    depends_on "linuxbrew/xorg/xcb-util-image"
    depends_on "linuxbrew/xorg/xcb-util-keysyms"
    depends_on "linuxbrew/xorg/xcb-util-renderutil"
    depends_on "linuxbrew/xorg/xcb-util-wm"
    depends_on "pulseaudio"
    depends_on "python"
    depends_on "systemd"
    depends_on "zstd"
  end

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"

  # Fix build on 10.15.4 SDK, included in 5.15
  # https://github.com/qt/qtwebengine/commit/5d2026cb04ef8fd408e5722a84e2affb5b9a3119
  patch :DATA

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
      args << "-system-xcb"
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

    inreplace %w[qtdeclarative/qtdeclarative.pro qtdeclarative/src/3rdparty/masm/masm.pri] do |s|
      s.gsub! "python ", "python3 "
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

__END__
--- a/qtwebengine/src/buildtools/config/mac_osx.pri
+++ b/qtwebengine/src/buildtools/config/mac_osx.pri
@@ -9,6 +9,10 @@
      isEmpty(QMAKE_MAC_SDK_VERSION): error("Could not resolve SDK version for \'$${QMAKE_MAC_SDK}\'")
 }
 
+# chromium/build/mac/find_sdk.py expects the SDK version (mac_sdk_min) in Major.Minor format.
+# If Patch version is provided it fails with "Exception: No Major.Minor.Patch+ SDK found"
+QMAKE_MAC_SDK_VERSION_MAJOR_MINOR = $$section(QMAKE_MAC_SDK_VERSION, ".", 0, 1)
+
 QMAKE_CLANG_DIR = "/usr"
 QMAKE_CLANG_PATH = $$eval(QMAKE_MAC_SDK.macx-clang.$${QMAKE_MAC_SDK}.QMAKE_CXX)
 !isEmpty(QMAKE_CLANG_PATH) {
@@ -28,7 +32,7 @@
     clang_base_path=\"$${QMAKE_CLANG_DIR}\" \
     clang_use_chrome_plugins=false \
     mac_deployment_target=\"$${QMAKE_MACOSX_DEPLOYMENT_TARGET}\" \
-    mac_sdk_min=\"$${QMAKE_MAC_SDK_VERSION}\" \
+    mac_sdk_min=\"$${QMAKE_MAC_SDK_VERSION_MAJOR_MINOR}\" \
     use_external_popup_menu=false
 
 qtConfig(webengine-spellchecker) {
