class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.3.2.tar.gz"
  sha256 "42f670c132be6cd2bb185175caf22ffdb3042c7c4f3aadaf30579460226ab455"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03e6dad49603c022c982f4de466e0559822d4b405b7adb6d658592b35712efaf"
    sha256 cellar: :any_skip_relocation, big_sur:       "14ee0bb4fe410a81bebaccd0d40f62d5ce63a5134e77fdc0df0d5ffbfd57e5bf"
    sha256 cellar: :any_skip_relocation, catalina:      "0d6b6f08d97d12a6cbe43b1a8f3e451fd752de4d5742a306ffca72f82a4b800f"
    sha256 cellar: :any_skip_relocation, mojave:        "85fbb6b99044964af0d54f4ae89089d65d57c05d500f9601be0b18188be2f18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a07bc53ed0a419ba137ef39bbca7e0001ab17b93c53176321e6982658181ca6" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DROARING_BUILD_STATIC=ON", *std_cmake_args
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
