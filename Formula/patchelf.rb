class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://nixos.org/releases/patchelf/patchelf-0.11/patchelf-0.11.tar.gz"
  sha256 "e52378cc2f9379c6e84a04ac100a3589145533a7b0cd26ef23c79dfd8a9038f9"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "91944c42c39963a6a4c39fa330062ed1d269b0a2be0b5010ae6bac61cff16e53" => :catalina
    sha256 "8a5e731cb4724804c386ffd3218b47a4adb06a86003929d03d24ae8d388c7722" => :mojave
    sha256 "7646ae37a16d2e63594a7ebefb482884f3e60fc7089acb72e0b2aea49659bdf0" => :high_sierra
  end

  resource "helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    # Fix ld.so path and rpath
    # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
    unless OS.mac?
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
      "CXXFLAGS=-static-libgcc -static-libstdc++",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
