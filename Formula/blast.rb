class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  mirror "http://mirrors.vbi.vt.edu/mirrors/ftp.ncbi.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  version "2.7.1"
  sha256 "10a78d3007413a6d4c983d2acbf03ef84b622b82bd9a59c6bd9fbdde9d0298ca"

  bottle do
    sha256 "13e0286489e2b28adbe3fc6ef82a26f3e081b44a0ce99f3212a0c4d7da981b3a" => :high_sierra
    sha256 "a868633034dc12160109ee44e5415577967e2ceabaad3246881abaf07c57a198" => :sierra
    sha256 "110a62423f43f3618aadc5a149c238302af30399426346e571e23f252f8e6bab" => :el_capitan
    sha256 "f434242e0b337c0b13f62e1b0ce5e8735d5aab0b698320691cafa9900340e1c5" => :x86_64_linux
  end

  depends_on "lmdb"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "cpio" => :build unless OS.mac?

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    cd "c++" do
      # Use ./configure --without-boost to fix
      # error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
      # Boost is used only for unit tests.
      # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
      system "./configure", "--prefix=#{prefix}",
                            "--without-debug",
                            "--without-boost"

      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"

      system "make", "install"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
