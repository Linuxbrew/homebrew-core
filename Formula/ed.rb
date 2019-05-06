class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.15.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.15.tar.lz"
  sha256 "ad4489c0ad7a108c514262da28e6c2a426946fb408a3977ef1ed34308bdfd174"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5e928abc1cb9805d5af7c20862dd34158fce16a40b081e7fbf2d0831eee4823e" => :mojave
    sha256 "f0c6117b99056bb8d56538e31cf2ba6213d3f4f3eb6527dc566636eb9cd07595" => :high_sierra
    sha256 "04e745994129682e6d11caa6ce047a76da39c448403d4723fce2560c3603faef" => :sierra
    sha256 "579a26dd5974c162e798e93576239ded960b93531361a27cf970b6af3d4dd6b5" => :x86_64_linux
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", *("--program-prefix=g" if OS.mac?)
    system "make"
    system "make", "install"

    if OS.mac?
      %w[ed red].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    if OS.mac?
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    end

    unless OS.mac?
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end
