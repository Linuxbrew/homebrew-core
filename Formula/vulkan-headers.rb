class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.140.tar.gz"
  sha256 "c708a05b0ef673ae783f8968c5396dc207b9f8c7cde2ddb4a9a281e04661185a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :catalina
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :mojave
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :high_sierra
    sha256 "ce8112cfcef3e5be8eb234f4f3d0e5d47aece30dfd67395b826f88da272473a1" => :x86_64_linux
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
