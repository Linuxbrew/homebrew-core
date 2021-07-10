class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20210622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20210622.tar.bz2"
  sha256 "7b33279bf71e76c52c393081d2db69057dd320be019759c4e704841a6761ec86"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e0165ed1310328267d9ec1225f107f7a67b917ffc0bdee2971cf24a1a86b4de" # linuxbrew-core
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    inreplace_files = [
      bin/"parallel",
      doc/"parallel.texi",
      doc/"parallel_design.texi",
      man1/"parallel.1",
      man7/"parallel_design.7",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
