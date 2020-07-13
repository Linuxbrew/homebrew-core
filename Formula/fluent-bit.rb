class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.6.tar.gz"
  sha256 "3ff32b163eb57c6f82fa4a8e3d2797f1896a43a65667c6fffaf7b7f8f8f1e8ee"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "d2ed76145fb4b004eadb4a57007238e48faa97e81f2bd37a62b26f7cab2ea8b5" => :catalina
    sha256 "2573b4dd23cf4b578eb02eaa5509a2b2a9d87325e7c87cb4eeb34eb78c672224" => :mojave
    sha256 "4588a0fb9ea77b998f3e36d23b6c2ce293e8015d6b5b51204e53b84ee0550983" => :x86_64_linux
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  # bug report, https://github.com/fluent/fluent-bit/issues/2332
  depends_on :macos => :mojave

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries"
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries"

  # Don't install service files
  patch :DATA unless OS.mac?

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check -fno-common" if DevelopmentTools.clang_build_version >= 1010

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 54b3b291..72fd1088 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -316,27 +316,6 @@ if(FLB_BINARY)
     ENABLE_EXPORTS ON)
   install(TARGETS fluent-bit-bin RUNTIME DESTINATION ${FLB_INSTALL_BINDIR})

-  # Detect init system, install upstart, systemd or init.d script
-  if(IS_DIRECTORY /lib/systemd/system)
-    set(FLB_SYSTEMD_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.service")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/systemd.in"
-      ${FLB_SYSTEMD_SCRIPT}
-      )
-    install(FILES ${FLB_SYSTEMD_SCRIPT} DESTINATION /lib/systemd/system)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  elseif(IS_DIRECTORY /usr/share/upstart)
-    set(FLB_UPSTART_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.conf")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/upstart.in"
-      ${FLB_UPSTART_SCRIPT}
-      )
-    install(FILES ${FLB_UPSTART_SCRIPT} DESTINATION /etc/init)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  else()
-    # FIXME: should we support Sysv init script ?
-  endif()
-
   install(FILES
     "${PROJECT_SOURCE_DIR}/conf/fluent-bit.conf"
     DESTINATION ${FLB_INSTALL_CONFDIR}
