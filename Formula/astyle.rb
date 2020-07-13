class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  if OS.mac?
    url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.1/astyle_3.1_macos.tar.gz"
    sha256 "c4eebbe082eb2cb98f90aafcce3da2daeb774dd092e4cf8b728102fded8d1dcf"
  elsif OS.linux?
    url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.1/astyle_3.1_linux.tar.gz"
    sha256 "cbcc4cf996294534bb56f025d6f199ebfde81aa4c271ccbd5ee1c1a3192745d7"
  end
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bffda383a58eb65c458e00a9cc7dcb3b852a1b5e89a830df7e6eeb594a92f3c" => :catalina
    sha256 "65a2f71d86cbc112f12729a0845f47f718cb2751e2e1ccdd78c6c4fc4ad6e817" => :mojave
    sha256 "a58fdf5320a691b37337973e0ca43d2e69f42adbc96d6ab160066c3574373047" => :high_sierra
    sha256 "7a3ff647da72399ee8aa05f1c55806b3bc273409e4a7b2ab0f68930227a47b5f" => :sierra
    sha256 "e6eb9d95f56fa99005173fcd1c147f9335f55c9ccf52067f57da36e95f7f4c7e" => :el_capitan
    sha256 "6a9ffbe6d6e56b46c9a01b7ff4571e44a409a353db7afdc25fab6f905af250c3" => :x86_64_linux
  end

  def install
    cd "src" do
      dir = OS.mac? ? "mac" : "gcc"
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/#{dir}/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
