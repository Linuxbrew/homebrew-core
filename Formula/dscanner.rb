# dscanner: Build a bottle for Linuxbrew
class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.5",
      :revision => "e9d17fdc3bca8683b4b357c7ab821f9123897c26"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "7d9c494170478961cf007fd281843f6afb2eb1b04a7577ca9c5160b28237cb43" => :high_sierra
    sha256 "b817ae9a6b91879a7084aea4457501094e0d86b4a684413456d75d67d3217f51" => :sierra
    sha256 "75d8b7425ba5d7174fa6dd47d03b60bf5f1d6373dae23aa4b8730a0d0b3f58d1" => :el_capitan
    sha256 "7e09fe3cb2f255906ed91ab1c2fc2ff3c9fcb784f836f40da8bfa605b7464197" => :x86_64_linux
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
