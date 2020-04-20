class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.4.tar.gz"
  sha256 "02265e0229675aea3a413164b43004045617174bdb2c92bf6782f618f8796b55"

  bottle do
    cellar :any
    sha256 "7807fe7e391bdf454d02269d67cf5691734f2f005005e7dc10078fbb0f3f23be" => :catalina
    sha256 "b3443925fba4f35223ffd7d447711db6aeeb8ae209c94412ae0c74bc7bd4b2bb" => :mojave
    sha256 "a357840146dba6b819eaf287317f421cc9b1cd3d00f455bb4d0c5ff105e10b7c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
