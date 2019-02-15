# valabind: Build a bottle for Linuxbrew
class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "a1d10cd047c3138073ca801e9b329099b54699934c10c5b0d19f0715700427ae" => :mojave
    sha256 "1ea10f1718863eab9d776ffa851ed373a9e2acb36ade53facd63f9b0cfd045e9" => :high_sierra
    sha256 "d034e9ab2b3f8ac4fcd9396813cbb39d048006a8889cb4162c26b7b78787a296" => :sierra
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
