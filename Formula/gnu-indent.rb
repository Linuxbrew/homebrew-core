class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftp.gnu.org/gnu/indent/indent-2.2.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/indent/indent-2.2.12.tar.gz"
  sha256 "e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"

  bottle do
    rebuild 3
    sha256 "424a7f469abb096382488440e00d55021d97405d8e72948cff93fb7826f71285" => :mojave
    sha256 "ef3e9fa08a9cf100dcd9d5e85a17c88791b78fee201eba5ce8935da5072e4670" => :high_sierra
    sha256 "73fb630f7391e4598bfeb823637f67ba8741926133813f00bde91dfd8a4f2972" => :sierra
    sha256 "bc68f4f37b89b8a66f79d2495d37fc5f7a893527fe27ccbe7fc6ef17b8148a22" => :x86_64_linux
  end

  depends_on "gettext"
  # Fix WARNING: 'makeinfo' is missing on your system.
  depends_on "texinfo" => :build unless OS.mac?

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gindent" => "indent"
      (libexec/"gnuman/man1").install_symlink man1/"gindent.1" => "indent.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      GNU "indent" has been installed as "gindent".
      If you need to use it as "indent", you can add a "gnubin" directory
      to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    system "#{bin}/gindent", "test.c" if OS.mac?
    system "#{bin}/indent", "test.c" unless OS.mac?
    assert_equal File.read("test.c"), <<~EOS
      int
      main ()
      {
        return 0;
      }
    EOS
  end
end
