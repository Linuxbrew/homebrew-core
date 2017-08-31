class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.51b.tgz"
  sha256 "d435b94b35b844ea0bacbdb8516d2d5adffc2a4f4a5aad78785c5d2a5495bb97"

  bottle do
    sha256 "be69a4fe98d4501983bec3575251c712f22ad9b355359e8c8ba62f39e36c6a33" => :sierra
    sha256 "536f62577917c30763e1a804e3de3bc13b36b5396b591ed32a448a010eadc39c" => :el_capitan
    sha256 "ad729b9aaf30d8250aa55ea82223347d4e8f1f21f5635ff9d4de10eb1256585f" => :yosemite
    sha256 "b12edd6a5b8496c0484a34000c82b7edc239148b75a2ee03922139c55d53ae05" => :x86_64_linux
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<-EOS.undent
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    if which "clang++"
      system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    else
      system bin/"afl-g++", "-g", cpp_file, "-o", "test"
    end
    assert_equal "Hello, world!", shell_output("./test")
  end
end
