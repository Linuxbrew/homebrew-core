class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.18.63.tar.gz"
  sha256 "589a2da635281f84516608bb3bd641ec905c43e157e81921bf80c63fe64eb57c"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ee87dd44d9a8adc3984bd589598f8e7a3b256863b0f6e895ee90f8a46e54bd6" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
