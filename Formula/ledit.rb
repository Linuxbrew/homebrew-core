class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/ledit-2-05.tar.gz"
  version "2.05"
  sha256 "493ee6eae47cc92f1bee5f3c04a2f7aaa0812e4bdf17e03b32776ab51421392c"

  livecheck do
    url :homepage
    regex(/current .*? is v?(\d+(?:\.\d+)+) /i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "2d404ace597c8a7062fbe96e15e9e7d1226ec5ca97e0c8981062c77fef10b4eb"
    sha256 cellar: :any_skip_relocation, catalina:     "158141ebf4edc253de428b8789d77eae0b19fdd4d8002e9910cf4c2486a12bb6"
    sha256 cellar: :any_skip_relocation, mojave:       "463dd47cebd8510a630e39008b001e52659f64f1bcda7503bdc8a0f28e55adfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "61348dd368939356df214df67e8bd80791b9e24721058ac134e7f38106e2e168"
  end

  depends_on "camlp5"
  depends_on "ocaml"

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert_predicate history, :exist?
    assert_equal "exit\n", history.read
  end
end
