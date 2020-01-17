# openjdk: Build a bottle for Linux
class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk13u/archive/jdk-13.0.2+8.tar.bz2"
  version "13.0.2+8"
  sha256 "01059532335fefc5e0e7a23cc79eeb1dc6fea477606981b89f259aa0e0f9abc1"

  bottle do
    cellar :any
    sha256 "8fc66526646d9787cf6f08dd978fbca7ec59b51846199568e5845fbddb9610c6" => :catalina
    sha256 "38f353fd52a84f5890dda7fd20b76e79f6280cbd427495254be356ee8730fb92" => :mojave
    sha256 "447fd4616e32bba4fc8a8de5865df15795da1c5f6b5d233f8f3aeb771f522f3c" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "unzip"
    depends_on "zip"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxrandr"
    depends_on "linuxbrew/xorg/libxrender"
    depends_on "linuxbrew/xorg/libxt"
    depends_on "linuxbrew/xorg/libxtst"
  end

  resource "boot-jdk" do
    if OS.mac?
      url "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_osx-x64_bin.tar.gz"
      sha256 "675a739ab89b28a8db89510f87cb2ec3206ec6662fb4b4996264c16c72cdd2a1"
    else
      url "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz"
      sha256 "75998a6ebf477467aa5fb68227a67733f0e77e01f737d4dfbc01e617e59106ed"
    end
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = OS.mac? ? boot_jdk_dir/"Contents/Home" : boot_jdk_dir
    java_options = ENV.delete("_JAVA_OPTIONS")

    short_version, _, build = version.to_s.rpartition("+")

    chmod 0755, "configure"
    system "./configure", "--without-version-pre",
                          "--without-version-opt",
                          "--with-version-build=#{build}",
                          "--with-toolchain-path=/usr/bin",
                          ("--with-extra-ldflags=-headerpad_max_install_names" if OS.mac?),
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-debug-level=release",
                          "--with-native-debug-symbols=none",
                          "--enable-dtrace=auto",
                          "--with-jvm-variants=server",
                          ("--with-x=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-cups=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-fontconfig=#{HOMEBREW_PREFIX}" unless OS.mac?)

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    if OS.mac?
      libexec.install "build/macosx-x86_64-server-release/images/jdk-bundle/jdk-#{short_version}.jdk" => "openjdk.jdk"
      bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    else
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
    EOS
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
