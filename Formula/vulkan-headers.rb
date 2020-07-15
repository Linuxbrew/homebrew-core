class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.147.tar.gz"
  sha256 "8ff13998c7384d5f0d22e0258122b02c0efe7c115928701b591e96eb78e3f354"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2dbd1467874f539b416aa5594069efdb1b7e9b64a96546d20d7a89c3d5c0b94" => :catalina
    sha256 "a2dbd1467874f539b416aa5594069efdb1b7e9b64a96546d20d7a89c3d5c0b94" => :mojave
    sha256 "a2dbd1467874f539b416aa5594069efdb1b7e9b64a96546d20d7a89c3d5c0b94" => :high_sierra
    sha256 "101a490be4c65e4c7ba3770aba1530fc1e3354ca50160cd2781e225cab69e37a" => :x86_64_linux
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
