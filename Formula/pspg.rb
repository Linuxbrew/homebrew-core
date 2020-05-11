class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.0.7.tar.gz"
  sha256 "10d82c4b0112e51d397ea8f70c973c6d085aa964381ecc950a1cd8a7b4af72da"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "8277e8401d2d41cd1766e10ca2165c6c2f636e422861267a1f7bb26efaa996e1" => :catalina
    sha256 "bae0d9f32744919fdd76d447aa275d643d4271dd2a2c19e607571cce811929af" => :mojave
    sha256 "0c001fc331c10504a0ea5c475013eb650bc00a38d3f1cd42faffe47c623d740f" => :high_sierra
    sha256 "7a93ff4b2c211c0305990236e62a6527ce36de89951887753f3e0f2c4245b3f3" => :x86_64_linux
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version", 1)
  end
end
