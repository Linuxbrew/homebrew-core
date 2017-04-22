# icarus-verilog: Build a bottle for Linuxbrew
class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.1.1.tar.gz"
  sha256 "fdaa75dfe7c58cbc471fc12710ee49b3f32fd6cc055d9181b5190cbcbbd6cada"

  bottle do
    sha256 "407f39365da527c4bfe390ea77756f8e1711bc5f97bb62c39c43a70ec1ea0409" => :sierra
    sha256 "765e2758490a45edc6b4145e2e22eb0e82c6cb43b877bcf439a2da13f9f55bcb" => :el_capitan
    sha256 "80af17509dd602b4f9e5c6c05add05b5a84337b20e231a05889c96776386ccdb" => :yosemite
    sha256 "7d7c2dcd88f2e6b2307fcafa733307439be48e266b734306b5ee7f60eb650d41" => :x86_64_linux
  end

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "gperf" => :build
    depends_on "bzip2"
    depends_on "readline"
    depends_on "zlib"
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<-EOS.undent
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp
  end
end
