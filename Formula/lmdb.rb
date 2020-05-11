class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.25/openldap-LMDB_0.9.25.tar.bz2"
  sha256 "45269ebbf13fe1b6a3aa3fa77b3109c1764bd17a95264cd56506eac832b91b6f"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", :branch => "mdb.master"

  bottle do
    cellar :any
    sha256 "22dcd49d0d1027f6acef65aeb8f08422f9482daecf4c75b1add02f5368bfd96e" => :catalina
    sha256 "2e9006940427302ed31c4972d47a998be797c669e2d75056107fcf28974f43e7" => :mojave
    sha256 "445091428bfb6ca3712290c3484dcba219a6e4ab935829050e0c4caf0bc7b1b3" => :high_sierra
    sha256 "3452460075121e2d4225d4583821ade40225f85f518922df5b78d0feb3d95f89" => :x86_64_linux
  end

  def install
    cd "libraries/liblmdb" do
      args = *("SOEXT=.dylib" if OS.mac?)
      system "make", *args
      system "make", "install", "prefix=#{prefix}", *args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
