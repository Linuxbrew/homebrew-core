class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.5.tar.xz"
  sha256 "a3d4c0e0dadd4c64962205d2f448af72d6bd8c67919d984012b8a41b843ec757"

  bottle do
    sha256 "9b978ec2cc436daa0a108b6495347c38d73abc548735ccbe16a451c834f27998" => :catalina
    sha256 "7795d99f608f038329510e1f357e94413eb2ba1d9db44a230764bc932a09acd5" => :mojave
    sha256 "dc00e3cab23552bf274a15d5a86fee0ac5bcc67df11b129ef4433b7ce94adbc9" => :high_sierra
    sha256 "ef635ce8291420cd263b01875cd0b5a0e473b44691966e24b9f3caa2b69631fa" => :x86_64_linux
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  depends_on "linuxbrew/xorg/libx11" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
