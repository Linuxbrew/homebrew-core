class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://github.com/catchorg/Catch2/archive/v2.12.1.tar.gz"
  sha256 "e5635c082282ea518a8dd7ee89796c8026af8ea9068cd7402fb1615deacd91c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :catalina
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :mojave
    sha256 "a5e3629556bfd21e1376c3d05ee459bd29d0065480e1c76c1fcf93d9656542ea" => :high_sierra
    sha256 "5f7b9832e53030aa3fadfed1600619d137adfd9d56fb6636d439869da2f2265f" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define CATCH_CONFIG_MAIN
      #include <catch2/catch.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
