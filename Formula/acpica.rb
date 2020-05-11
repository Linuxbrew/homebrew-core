class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200430.tar.gz"
  sha256 "fb807f1dec31664f972af37d213abf72987afe33abf68c83051e298da35d297c"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "479bdacc3695e96c078c9345d17febe0028b7972929f46e601c3d651182b626d" => :catalina
    sha256 "17dbfaf84f468f6e4a86d383ea4c30e60995a8f3b666ac230d5ac11995a0a797" => :mojave
    sha256 "6cb8548285547bf427709f04b57bdf82ed5e10c65f0b3161ca947c8d60e968aa" => :high_sierra
    sha256 "e0d72cc1522be0486b5228d77ecc9e482d638c36d9ec979809d1764a5e69996d" => :x86_64_linux
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
