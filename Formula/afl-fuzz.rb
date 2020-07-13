class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.57b.tar.gz"
  version "2.57b"
  sha256 "a6416350ef40e042085337b0cbc12ac95d312f124d11f37076672f511fe31608"
  license "Apache-2.0"

  bottle do
    sha256 "958368e0937e051e3330ffa78f93481f8c729a104b87fd24c04ff067fb8780ec" => :catalina
    sha256 "82fb4d89ca48bc6a48c6d583497fcb48aa8e1fe7c00db57f0391881ab4a851c0" => :mojave
    sha256 "2fea83e82eca377b8adaf58a3b7f4577336db1a00f931170e0abc94a5c431529" => :high_sierra
    sha256 "badf96b23a6c95039306766df14e69b9b03409b97efdccca23b8f6520ba6600a" => :x86_64_linux
  end

  def install
    defs = ["PREFIX=#{prefix}"]
    defs << "AFL_NO_X86=1" unless OS.mac?
    system "make", *defs
    system "make", "install", *defs
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
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
