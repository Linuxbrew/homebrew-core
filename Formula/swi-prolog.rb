class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.2.4.tar.gz"
  sha256 "f4bcc78437f9080ab089762e9e6afa7071df7f584c14999b92b9a90a4efbd7d8"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 x86_64_linux: "12ecb163975e72690071c6011e3c7e50b6460ddc493a8c6ae8900aa96969b985" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DSWIPL_PACKAGES_JAVA=OFF",
                      "-DSWIPL_PACKAGES_X=OFF",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    on_linux do
      inreplace "libexec/lib/swipl/bin/x86_64-linux/swipl-ld",
        HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
      inreplace "libexec/lib/swipl/lib/x86_64-linux/libswipl.so.#{version}",
        HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
