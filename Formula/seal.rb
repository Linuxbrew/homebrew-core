class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.5.5.tar.gz"
  sha256 "ae987c9df02a0a887eeb96032f307781b945183d3433e54a0a6d59207f4b8143"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "12adc544597410eae07005a732a62674239d8e077c5b008a25236f88f51e19ff" => :catalina
    sha256 "b08f8c23b71294bab6e3fd5ee47287e206fd9fd40a9f118c7a4841a3d05091c3" => :mojave
    sha256 "209febb2b7bab29322a3945f660a1b6f4689fc28e3f09aa0db3e3f43b2f24ba3" => :high_sierra
    sha256 "fdc51b8f47971a03ca888956ce295a543f146f41c56b726c5197ceef6445b98d" => :x86_64_linux
  end

  depends_on "cmake" => [:build, :test]

  # #pragma GCC error "SEAL requires __GNUC__ >= 6"
  # In reality gcc@6 does not work because of some missing C++17 features.
  unless OS.mac?
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    fails_with :gcc => "7"
    depends_on "gcc@8" => [:build, :test]
  end

  def install
    system "cmake", "-DBUILD_SHARED_LIBS=ON", ".", *std_cmake_args
    system "make"
    system "make", "install"
    pkgshare.install "native/examples"
  end

  test do
    ENV["CXX"] = Formula["gcc@8"].opt_bin/"g++-8" unless OS.mac?
    cp_r (pkgshare/"examples"), testpath

    # remove the partial CMakeLists
    File.delete testpath/"examples/CMakeLists.txt"

    # Chip in a new "CMakeLists.txt" for example code tests
    (testpath/"examples/CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.12)
      project(SEALExamples VERSION #{version} LANGUAGES CXX)
      # Executable will be in ../bin
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SEALExamples_SOURCE_DIR}/../bin)

      add_executable(sealexamples examples.cpp)
      target_sources(sealexamples
          PRIVATE
              1_bfv_basics.cpp
              2_encoders.cpp
              3_levels.cpp
              4_ckks_basics.cpp
              5_rotation.cpp
              6_serialization.cpp
              7_performance.cpp
      )

      # Import Microsoft SEAL
      find_package(SEAL #{version} EXACT REQUIRED
          # Providing a path so this can be built without installing Microsoft SEAL
          PATHS ${SEALExamples_SOURCE_DIR}/../src/cmake
      )

      # Link Microsoft SEAL
      target_link_libraries(sealexamples SEAL::seal)
    EOS

    system "cmake", "examples"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
