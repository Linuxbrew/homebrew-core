# vulkan-headers: Build a bottle for Linux
class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.127.tar.gz"
  sha256 "81252bb9170e938212cc16557e9cf0d91f639e55e34e41b1355f96515c81ed73"

  bottle do
    cellar :any_skip_relocation
    sha256 "59d67e697b206975e6695cce8fbee62a627848ac21346f4caf18f4358e70aa2a" => :catalina
    sha256 "59d67e697b206975e6695cce8fbee62a627848ac21346f4caf18f4358e70aa2a" => :mojave
    sha256 "59d67e697b206975e6695cce8fbee62a627848ac21346f4caf18f4358e70aa2a" => :high_sierra
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
