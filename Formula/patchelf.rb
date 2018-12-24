class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://nixos.org/patchelf.html"
  url "https://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.gz"
  sha256 "f2aa40a6148cb3b0ca807a1bf836b081793e55ec9e5540a5356d800132be7e0a"
  revision 2 unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "f079a1cb7d49867669704e55758484b3098b9f8ec6cc3600611ea43d5ff7b3cc" => :mojave
    sha256 "c97defd1aa773a8b3a36ce9941f860bd0d4348c47beb97e2c59e43c096234fd6" => :high_sierra
    sha256 "8994925b02e7d2ce043df104ceb64b959543e1a869dd126b02c00f0f6a20bfd0" => :sierra
    sha256 "38c85e00a1dc54d103713d04a0d458c55cf3f2618d2a7848f5750f66068206d2" => :el_capitan
  end

  head do
    url "https://github.com/NixOS/patchelf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-static", "Link statically"
  option "without-static-libstdc++", "Link libstdc++ dynamically"

  resource "hellworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  # https://github.com/NixOS/patchelf/pull/149
  patch do
    url "https://gist.githubusercontent.com/iMichka/5ccb2bac3ee421bc3cbc51079e0e35c8/raw/e848359f5b459b58479d226d349f75337b749f6b/patchelf.patch?full_index=1"
    sha256 "8d1816eea7407e8fa0b112f84a2e9155f20a7855a8a72c0d88619785d5042390"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
      if build.with?("static") then "CXXFLAGS=-static"
      elsif build.with?("static-libstdc++") then "CXXFLAGS=-static-libgcc -static-libstdc++"
      end,
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("hellworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
