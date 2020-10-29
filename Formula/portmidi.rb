class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/portmidi-src[._-]v?(\d+)\.}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "66b8773aa12201f7fa2bf44044ab32bdab1cdf763db870fde3f0bd7254c5d877" => :catalina
    sha256 "2a6258da2f83b668c2ba85edd9e49313114af5bfb288ebc681bd4cde221279c6" => :mojave
    sha256 "61f9a94aaca3f317c50e643b06617804d37798e32dd1cfcc1c24aecdc24aec75" => :high_sierra
  end

  depends_on "cmake" => :build

  depends_on "openjdk" unless OS.mac?

  # Fix incorrect use of CMAKE_CACHEFILE_DIR that results in output dir being set to /Release
  # (see https://gitlab.kitware.com/cmake/cmake/-/issues/18168#note_432059).
  # Also fixes https://stackoverflow.com/a/14226042/473909.
  patch :DATA unless OS.mac?

  def install
    if OS.mac?
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      # need to create include/lib directories since make won't create them itself
      include.mkpath
      lib.mkpath

      # Fix outdated SYSROOT to avoid:
      # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
      inreplace "pm_common/CMakeLists.txt",
                "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
                "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
    else
      ENV.deparallelize
      ENV["JAVA_HOME"] = Formula["openjdk"].libexec

      # replace hard-coded prefixes
      dirs = ["pm_common", "pm_dylib", "pm_java"]
      dirs.each do |d|
        inreplace "#{d}/CMakeLists.txt", "/usr/local", prefix
      end
      inreplace "pm_java/CMakeLists.txt", "/usr/share/java", libexec

      system "cmake", ".", *std_cmake_args

      system "make"
      system "make", "install"

      rm bin/"pmdefaults"
      bin.write_jar_script libexec/"pmdefaults.jar", "pmdefaults", "-Djava.library.path=#{lib}"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "portmidi.h"

      int main() {
      Pm_Initialize();
      Pm_Terminate();
      }
    EOS

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-lportmidi", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4919b78..ad0ba09 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -9,12 +9,12 @@ if(UNIX)
   set(CMAKE_BUILD_TYPE Release CACHE STRING 
       "Semicolon-separate list of supported configuration types")
   # set default directories but don't override cached values...
-  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
       CACHE STRING "libraries go here")
-  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
       CACHE STRING "libraries go here")
   set(CMAKE_RUNTIME_OUTPUT_DIRECTORY 
-      ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+      ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
       CACHE STRING "executables go here")
 
 else(UNIX)
@@ -54,13 +54,13 @@ if(UNIX)
   # then every other path is left alone
   if(CMAKE_LIBRARY_OUTPUT_DIRECTORY MATCHES ${BAD_DIR})
     set(CMAKE_RUNTIME_OUTPUT_DIRECTORY 
-        ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+        ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
         CACHE STRING "executables go here" FORCE)
     set(CMAKE_LIBRARY_OUTPUT_DIRECTORY 
-        ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+        ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
         CACHE STRING "libraries go here" FORCE)
     set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY 
-        ${CMAKE_CACHEFILE_DIR}/${CMAKE_BUILD_TYPE}
+        ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}
         CACHE STRING "libraries go here" FORCE)
   endif(CMAKE_LIBRARY_OUTPUT_DIRECTORY MATCHES ${BAD_DIR})
 endif(UNIX)
diff --git a/pm_java/CMakeLists.txt b/pm_java/CMakeLists.txt
index a350620..02720bb 100644
--- a/pm_java/CMakeLists.txt
+++ b/pm_java/CMakeLists.txt
@@ -16,12 +16,12 @@ if(UNIX)
         COMMAND javac -classpath . pmdefaults/PmDefaultsFrame.java
 	MAIN_DEPENDENCY pmdefaults/PmDefaultsFrame.java
 	DEPENDS pmdefaults/PmDefaults.java
-	WORKING_DIRECTORY pm_java)
+	WORKING_DIRECTORY .)
     add_custom_command(OUTPUT pmdefaults/PmDefaults.class
         COMMAND javac -classpath . pmdefaults/PmDefaults.java
 	MAIN_DEPENDENCY pmdefaults/PmDefaults.java
 	DEPENDS pmdefaults/PmDefaultsFrame.java
-	WORKING_DIRECTORY pm_java)
+	WORKING_DIRECTORY .)
     add_custom_command(OUTPUT ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pmdefaults.jar
         COMMAND	cp pmdefaults/portmusic_logo.png .
         COMMAND	jar cmf pmdefaults/manifest.txt pmdefaults.jar
@@ -32,8 +32,8 @@ if(UNIX)
 	COMMAND rm portmusic_logo.png
 	MAIN_DEPENDENCY pmdefaults/PmDefaults.class
 	DEPENDS ${PMDEFAULTS_ALL_CLASSES}
-	WORKING_DIRECTORY pm_java)
-    add_custom_target(pmdefaults_target ALL 
+	WORKING_DIRECTORY .)
+    add_custom_target(pmdefaults_target ALL
         DEPENDS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/pmdefaults.jar)
     # message(STATUS "add_custom_target: pmdefaults.jar")
 
