class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.0.tar.xz"
  sha256 "b97d9b041e5952486cab620b44ab09f6013a478f43b6699ae899b8a4da189cd4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :catalina
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :mojave
    sha256 "f39efe929465c1035f91d2a71e313a7d96f8644d052a057a87d62ae7173720e7" => :high_sierra
    sha256 "e0df2e6cf542b26a894c0cfddeac6c4faf257bdcd470d4c42c8503e2f280ad2d" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_predicate testpath/"test/compile-binding.am", :exist?
    assert_predicate testpath/"test/dist-changelog.am", :exist?
    assert_predicate testpath/"test/doc-reference.am", :exist?
    assert_predicate testpath/"test/generate-binding.am", :exist?
  end
end
