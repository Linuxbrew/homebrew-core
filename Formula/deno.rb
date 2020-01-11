class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.30.0/deno_src.tar.gz"
  version "0.30.0"
  sha256 "34fed174ed48b556f57d9727c7ee429518a8dd4c06993d51767039745ca1e6d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "cde94edda76a7d39ce8c1bbef540a1c9d09ad7f5cb8fa99030726a5ed9df108d" => :catalina
    sha256 "1790d5321ec0bbe25b1104ca9248a363ffd54bc2de382235a2ab172ee0b39556" => :mojave
    sha256 "9cce02d01848dc36dae9dc1b48c661979b01949a6f8e4b18c623e9a7a8021302" => :high_sierra
  end

  depends_on "llvm" => :build if OS.linux? || DevelopmentTools.clang_build_version < 1100
  depends_on "ninja" => :build
  depends_on "rust" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "python@2" => :build
    depends_on "xz" => :build
    depends_on "glib"
    depends_on "libxml2"
    depends_on "libxslt"
  end

  depends_on :xcode => ["10.0", :build] if OS.mac? # required by v8 7.9+

  # Use older revision on Linux, newer does not work.
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => OS.mac? ? "a5bcbd726ac7bd342ca6ee3e3a006478fd1f00b5" : "152c5144ceed9592c20f0c8fd55769646077569b"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    if OS.mac?
      if DevelopmentTools.clang_build_version < 1100
        # build with llvm and link against system libc++ (no runtime dep)
        ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
        ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
      else # build with system clang
        ENV["CLANG_BASE_PATH"] = "/usr/"
      end
    end

    cd "cli" do
      system "cargo", "install", "-vv", "--locked", "--root", prefix, "--path", "."
    end

    # Install bash and zsh completion
    output = Utils.popen_read("#{bin}/deno completions bash")
    (bash_completion/"deno").write output
    output = Utils.popen_read("#{bin}/deno completions zsh")
    (zsh_completion/"_deno").write output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    hello = shell_output("#{bin}/deno run hello.ts")
    assert_includes hello, "hello deno"
    cat = shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts #{testpath}/hello.ts")
    assert_includes cat, "console.log"
  end
end
