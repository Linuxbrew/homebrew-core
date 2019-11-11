# vala: Build a bottle for Linux
class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.4.tar.xz"
  sha256 "4bb9b60fc0230b0db2c8a0e2a80ec29f1c10b43dc78355abba78adedbc2e03a1"

  bottle do
    sha256 "aafe529673cf27ac6f99efd0f1764b8b9c5d9a9b6bfe0571c31978d1504b84e7" => :catalina
    sha256 "b0e4b699b7de352c39bdca7666dae60b9524fc83d2fa651c22a427fbf9823780" => :mojave
    sha256 "2e800031b4e9e2310ec616c845f1fdcf72cd741da873acb21b9eccbd967c07ad" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

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
