# tundra: Build a bottle for Linux
class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.12.tar.gz"
  sha256 "509e151d208bae039d6fd552294530cfb6a152e85eaae9a0221ce9e7c7533e21"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc64ded68e72f075e17af506b659e1845ed7f44e84353e02551748b7f0ee315" => :catalina
    sha256 "28503f4c9c034763e826103dfb687803ebb68a243d6762975d588fdfd19325b1" => :mojave
    sha256 "a4397eba195c1753ecc9839c367b91c0baf3404361e646f2b78728bcf6eeea0d" => :high_sierra
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    if OS.mac?
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "macosx-clang",
              DefaultOnHost = "macosx",
              Tools = { "clang-osx" },
            },
          },
        }
      EOS
    else
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "linux-gcc",
              DefaultOnHost = "linux",
              Tools = { "gcc" },
            },
          },
        }
      EOS
    end
    system bin/"tundra2"
    if OS.mac?
      system "./t2-output/macosx-clang-debug-default/test"
    else
      system "./t2-output/linux-gcc-debug-default/test"
    end
  end
end
