class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.38.3",
      revision: "d23bb4e549a9ec8f29aa66f7e9e495371033a424"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "de86e286b66786a1a15ea3ce8e6bd23a5b227fc9928ae6e6e3a498216f0002d8"
    sha256 cellar: :any_skip_relocation, catalina:     "b719919818567d4e2e84841dc091539c1341aa9645507af67b729b91a5c5e260"
    sha256 cellar: :any_skip_relocation, mojave:       "76ed9cf292056eb0a65758c5949435bff36522e987f316701cadbd0a13971787"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b5fd79210b5bdd392d45c6f08f3d66227c947279393198705918e269ca004154"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    unless OS.mac?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"/usr/bin/gcc\""
    end

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
