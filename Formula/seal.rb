class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.5.1.tar.gz"
  sha256 "9dfb1482d0bade6c1c76f2aa06aca6203f98aadc4ad94ca0f316be916b45fbd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "52c0c69a916e496c79bf9ecb96b96a4c1f5251b4dc0b882caa75b4797f94ad85" => :catalina
    sha256 "965bf9e01fd2942ea460463f1d0ba980ed4dcc6c98db2d613ab9e7df4037cf4a" => :mojave
    sha256 "d8bb4cdf57efa3373547a0cd7b9ed5f259d5e7d96fd8e6754f532bcd78b4421a" => :high_sierra
    sha256 "1e9016f4276e2d251af777253904fcc50cefc4720c71d7c8f276d7fdfcc71cb2" => :x86_64_linux
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
      project(SEALExamples VERSION 3.5.1 LANGUAGES CXX)
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
      find_package(SEAL 3.5.1 EXACT REQUIRED
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
