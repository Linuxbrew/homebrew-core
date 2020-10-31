class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.5.0/deno_src.tar.gz"
  sha256 "ca6ff399d3f00586dd90e4578016f8efc5a728eb9cd600463f031d085019fe0e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "30796553060442b3420e0c8a6e549c5d50c75c28204af5b85bbd0e70d03578f4" => :catalina
    sha256 "9d723a16d07f43acae93ff622bdc553ff169b7249813662f2aa1949eceafe820" => :mojave
    sha256 "1187e58c2d8d9ea663929ca692817f424d46f22f84e7e6b2225243b56618ac49" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  def install
    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "core/libdeno/build/linux/sysroot_scripts/install-sysroot.py", "--arch=amd64" unless OS.mac?

    cd "cli" do
      system "cargo", "install", "-vv", *std_cargo_args
    end

    # Install bash and zsh completion
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write output
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
