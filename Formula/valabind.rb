# valabind: Build a bottle for Linuxbrew
class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.6.0.tar.gz"
  sha256 "0d266486655c257fd993758c3e4cc8e32f0ec6f45d0c0e15bb6e6be986e4b78e"
  revision OS.mac? ? 1 : 3
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c149f20a01849a3ee477d0ea236fd78fedd45d2c1fe8ebc97bdf637f2fa4cec5" => :mojave
    sha256 "9cc2312ef64b8f1d39a36d9b157d9112920ebdda221e64d0680b32e641e0a795" => :high_sierra
    sha256 "e9ffa47579200c0f8a1394c6495b1c8c52d581084bcd9273121d4e907fff307c" => :sierra
    sha256 "c43502d503c09c23f2c225250c5e8ccf9f7100b88703767f27ceed729b55a8c3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  patch do
    # Please remove this patch for valabind > 1.6.0.
    url "https://github.com/radare/valabind/commit/774707925962fe5865002587ef031048acbe9d89.patch?full_index=1"
    sha256 "d6a88a7c98ab0e001c4ce2d50e809ed4c4b9258954133434758d1f0c5e26f9e9"
  end

  def install
    unless OS.mac?
      # Valabind depends on the Vala code generator library during execution.
      # The `libvala` pkg-config file installed by brew isn't pointing to Vala's
      # opt_prefix so Valabind will break as soon as Vala releases a new
      # patchlevel. This snippet modifies the Makefile to point to Vala's
      # `opt_prefix` instead.
      vala = Formula["vala"]
      inreplace "Makefile", /^VALA_PKGLIBDIR=(.*$)/, "VALA_PKGLIBDIR_=\\1\nVALA_PKGLIBDIR=$(subst #{vala.prefix(vala.version)},#{vala.opt_prefix},$(VALA_PKGLIBDIR_))"
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
