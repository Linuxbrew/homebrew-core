# meson: Build a bottle for Linux
class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.52.1/meson-0.52.1.tar.gz"
  sha256 "0c277472e49950a5537e3de3e60c57b80dbf425788470a1a8ed27446128fc035"
  head "https://github.com/mesonbuild/meson.git"
  revision 1 unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :catalina
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :mojave
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python"

  # https://github.com/mesonbuild/meson/issues/2567#issuecomment-504581379
  patch :DATA

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
__END__
--- meson-0.47.2.orig/mesonbuild/minstall.py
+++ meson-0.47.2/mesonbuild/minstall.py
@@ -486,8 +486,11 @@ class Installer:
                         printed_symlink_error = True
             if os.path.isfile(outname):
                 try:
-                    depfixer.fix_rpath(outname, install_rpath, final_path,
-                                       install_name_mappings, verbose=False)
+                    if install_rpath:
+                        depfixer.fix_rpath(outname, install_rpath, final_path,
+                                           install_name_mappings, verbose=False)
+                    else:
+                        print("RPATH changes at install time disabled")
                 except SystemExit as e:
                     if isinstance(e.code, int) and e.code == 0:
                         pass
