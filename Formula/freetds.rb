class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.36.tar.gz"
  sha256 "1c306e658e10a325eefddfd662cec3a6d9065fe61c515f26d4f1fb6c4c62405d"

  bottle do
    sha256 "a3e22cf599c870153f33d225e8839078c6c2c759e98f620541aa671f7cdcff89" => :catalina
    sha256 "395b46028182ffba1cf5975272551c440ba6398c1a6c32c6a24eda83105fb612" => :mojave
    sha256 "6df1c0993d1d06beffb798e39382ceb8f820ced333a4dcaf9925d3712d1b56f7" => :high_sierra
    sha256 "bee60bbe03a3d807f3bc6505073e6321ed2127536f35ec3788617380482f3b9c" => :x86_64_linux
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  depends_on "readline" unless OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
