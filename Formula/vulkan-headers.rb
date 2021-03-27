class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.173.tar.gz"
  sha256 "97ccee5ad5250b12624a89fe7b234d90befdebf0ae88734a95654efa4af2675c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c52ea0d7b651e847ca220a17484837c2a044da06f2d9d8ed8a5c42387b89742d"
    sha256 cellar: :any_skip_relocation, big_sur:       "faf508ab043b21e7931e31b16c42c8567376b990b07ba0e9810b1c98a03abbb1"
    sha256 cellar: :any_skip_relocation, catalina:      "3fb6dc94535487209b159ef4ad55e8af0941dc2d726e631aa3543cab769ac30e"
    sha256 cellar: :any_skip_relocation, mojave:        "91736e822f3f9958c6f72b906f2444e5903a5e38a0585861b6a478d7e57254be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c253f4e5d5eeb0a726401e43e6c7eead5b6a098650e551b12705bd22cf0f990"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
