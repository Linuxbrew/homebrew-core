class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.6.4.tar.gz"
  sha256 "a0fb90455de357e8647522fcd417d5060ca767bfec2372cda09107852e438205"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a563abafddc8c2d518d7a4107b62e531f92005db3ed2ceb954e8c7f59abe61a2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  uses_from_macos "zlib"

  # #pragma GCC error "SEAL requires __GNUC__ >= 6"
  # In reality gcc@6 does not work because of some missing C++17 features.
  depends_on "gcc" unless OS.mac?

  fails_with gcc: "5"

  resource "hexl" do
    url "https://github.com/intel/hexl/archive/tags/v1.0.1.tar.gz"
    sha256 "435bc6727a5d54e0b1fca0e2d21ac0fdf5bd8623fbd9015637d01ece931cc602"
  end

  def install
    if Hardware::CPU.intel?
      resource("hexl").stage do
        hexl_args = std_cmake_args + %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DHEXL_EXPORT=ON
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{(MacOS.version > :mojave) ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
      -DHEXL_DIR=#{lib}/cmake
      -DCMAKE_CXX_FLAGS=-I#{include}
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    pkgshare.install "native/examples"
  end

  test do
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-10" unless OS.mac?
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
      target_link_libraries(sealexamples SEAL::seal_shared)
    EOS

    system "cmake", "examples"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
