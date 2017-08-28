class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "http://www.nongnu.org/libunwind/"
  url "https://download.savannah.gnu.org/releases/libunwind/libunwind-1.2.tar.gz"
  sha256 "1de38ffbdc88bd694d10081865871cd2bfbb02ad8ef9e1606aee18d65532b992"
  head "git://git.sv.gnu.org/libunwind.git"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1914b746f6788024b000c723b0102f30bf4b3402a5b509d7d62f1d1375ef8d2d" => :x86_64_linux # glibc 2.19
  end

  depends_on "xz"

  def install
    system "./configure",
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #define UNW_LOCAL_ONLY
      #include <libunwind.h>
      #include <stdio.h>

      void backtrace() {
        unw_cursor_t cursor;
        unw_context_t context;

        unw_getcontext(&context);
        unw_init_local(&cursor, &context);

        while (unw_step(&cursor) > 0) {
          unw_word_t offset, pc;
          unw_get_reg(&cursor, UNW_REG_IP, &pc);
          if (pc == 0) break;
          printf("0x%lx:", pc);
          char sym[256];
          if (unw_get_proc_name(&cursor, sym, sizeof(sym), &offset) == 0)
            printf(" (%s+0x%lx)\\n", sym, offset);
          else
            printf(" -- error: unable to obtain symbol name for this frame\\n");
        }
      }

      void foo() { backtrace(); }
      void bar() { foo(); }
      int main(int argc, char **argv) { bar(); return 0; }
    EOS
    system ENV.cc, "-o", "test", "-Wall", "-g", "test.c", "-lunwind"
    output = shell_output("#{testpath}/test").split("\n")
    assert_match /0x\h*: \(foo\+0x\h*\)/, output[0]
    assert_match /0x\h*: \(bar\+0x\h*\)/, output[1]
    assert_match /0x\h*: \(main\+0x\h*\)/, output[2]
    assert_match /0x\h*: \(__libc_start_main\+0x\h*\)/, output[3]
    assert_match /0x\h*: \(_start\+0x\h*\)/, output[4]
    assert_match "#{testpath}/test.c:25", shell_output("addr2line #{output[0].split(":")[0]} -e #{testpath}/test").chomp
    assert_match "#{testpath}/test.c:26", shell_output("addr2line #{output[1].split(":")[0]} -e #{testpath}/test").chomp
    assert_match "#{testpath}/test.c:27", shell_output("addr2line #{output[2].split(":")[0]} -e #{testpath}/test").chomp
  end
end
