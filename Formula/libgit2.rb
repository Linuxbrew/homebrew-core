class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.0.0.tar.gz"
  sha256 "6a1fa16a7f6335ce8b2630fbdbb5e57c4027929ebc56fcd1ac55edb141b409b4"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "d9468719e8d981a91efea6ad25f83dd0d72300aef3f99c593844fbf440596de9" => :catalina
    sha256 "aa852c2192e21ccff73cee2b8819c5362083746e5cfbba06b6c38e3a5102b818" => :mojave
    sha256 "7f8ba85e6a7eff267eb1e750a85fc5d440858329ea9e2d674ec8900dd82ba3be" => :high_sierra
    sha256 "d1ef4d753f554e99daa796a28a7162d3507b540ae95e510b15fb992538964b60" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
