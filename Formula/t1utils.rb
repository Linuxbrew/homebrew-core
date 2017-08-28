class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.41.tar.gz"
  sha256 "fc5edd7e829902b3b685886382fed690d533681c0ab218a387c9e47606623427"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e108fcb6088b1c4d1fc1061de851efe3fb826d7353c21d8862216ef8857cd2" => :sierra
    sha256 "fc81594a73833517058d954a208275328ac7e90867ca6b3ca8d4a4553aa34be4" => :el_capitan
    sha256 "0983d0a649572d241ba27ae239888f56c3fe108bf00e2ca9faffd2306a44988f" => :yosemite
    sha256 "c8585753f1fb8e7b1e289d9f1b8727d1258142b456d9139145fea8964572d3a6" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
