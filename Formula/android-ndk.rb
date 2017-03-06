class AndroidNdk < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/ndk/index.html"
  if OS.mac?
    url "https://dl.google.com/android/repository/android-ndk-r14-darwin-x86_64.zip"
    sha256 "553b361453c2ad89a288f4aeb73902b1130d2d81f2e8702b9add7fbde5b83ce5"
  elsif OS.linux?
    url "https://dl.google.com/android/repository/android-ndk-r14-linux-x86_64.zip"
    sha256 "3e622c2c9943964ea44cd56317d0769ed4c811bb4b40dc45b1f6965e4db9aa44"
  end
  version "r14"
  version_scheme 1

  bottle :unneeded

  # As of r10e, only a 64-bit version is provided
  depends_on :arch => :x86_64
  depends_on "android-sdk" => :recommended

  conflicts_with "crystax-ndk",
    :because => "both install `ndk-build`, `ndk-gdb` and `ndk-stack` binaries"

  def install
    bin.mkpath

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-depends ndk-gdb ndk-stack ndk-which].each { |app| bin.install_symlink ndk_exec => app }
  end

  def caveats; <<-EOS.undent
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    https://developer.android.com/sdk/terms.html

    Software and System requirements at:
    https://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    cc = Utils.popen_read("#{bin}/ndk-which gcc").strip
    system cc, "-c", "test.c", "-o", "test"
  end
end
