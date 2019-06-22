class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 2
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "80c600b2b30861288dfe1a9738a23194e6ef6248d19c157f99432db87872e50d" => :mojave
    sha256 "113b9207da77e4bd15732cdac43b0ad7ac7aad4a511a4ad9e9ff87fc0922826e" => :high_sierra
    sha256 "f1166c36f5ca7b5bd95b88ddfa95d03e8e7aa049289450d4591778426709221c" => :sierra
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
