class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.1.tar.gz"
  sha256 "9d9ba0c4bf41ce7a1d7cae9a0efa83816a610b5e84077a02d02cffb8513a5b6d"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "23b5145a985a3e64c4d7045371f4db5f897e005dc321fb616820236b4c335108"
    sha256 cellar: :any, big_sur:       "daa8c6af2fd637fc529d9559193671cc2b0a26bad54f025afbcb6cc359088570"
    sha256 cellar: :any, catalina:      "34e12310d4454c1c1848d0ee38d5c81094e9c08df9891fd627bcf86130d1b49e"
    sha256 cellar: :any, mojave:        "d4cd8814a621b8e4d69ace9b1830fa81e57b3f641b6cf0919c5c5c377d40a772"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCAF_ENABLE_TESTING=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
