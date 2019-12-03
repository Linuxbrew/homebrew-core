# vulkan-headers: Build a bottle for Linux
class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.129.tar.gz"
  sha256 "95be9859edf30b36bb1e7653828e79cf508f1dc441a221a3b94659633da9b0f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5555621d636ee9dafa739240e35320e1b12a0ce7256ec5155cf811d6b56582" => :catalina
    sha256 "cb5555621d636ee9dafa739240e35320e1b12a0ce7256ec5155cf811d6b56582" => :mojave
    sha256 "cb5555621d636ee9dafa739240e35320e1b12a0ce7256ec5155cf811d6b56582" => :high_sierra
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
