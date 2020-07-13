class Scons < Formula
  include Language::Python::Shebang

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.1.2/scons-3.1.2.tar.gz"
  sha256 "7801f3f62f654528e272df780be10c0e9337e897650b62ddcee9f39fde13f8fb"
  revision OS.mac? ? 2 : 3

  bottle do
    cellar :any_skip_relocation
    sha256 "55f68a02463998b22e267af3089f00adfc3964b49d4c5f24dece2d1b08a92d99" => :catalina
    sha256 "55f68a02463998b22e267af3089f00adfc3964b49d4c5f24dece2d1b08a92d99" => :mojave
    sha256 "55f68a02463998b22e267af3089f00adfc3964b49d4c5f24dece2d1b08a92d99" => :high_sierra
    sha256 "7c5778e74eba8394cb5bf04ad9037308d873b8bc74ab2fc59b94df81ff5fa6fb" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    bin.find { |f| rewrite_shebang detected_python_shebang, f }
    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
