class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.15.0.tar.gz"
  sha256 "702b330d2938426679b3b0d50334b1518b4fb1d779220f2e32e68dfa1bb9fc0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf23ebb66078b8a02236dce0d10792d1f27a7683853702ced404ac25857bf815" => :catalina
    sha256 "ae0f2d5568a547176cb6f7998cf5a2cb29aa51575a272210b02bd000fe8f2d45" => :mojave
    sha256 "799c255bf21723f2388e24c07a39ecedd528d9cbfc2c1aa2ca7681c9ae15efaf" => :high_sierra
    sha256 "2f93c6501fd11624658933a6486d3876ab75701569f2c828eb07f3750b8a88ac" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "llvm" => :build unless OS.mac?

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
