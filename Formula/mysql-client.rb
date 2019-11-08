# mysql-client: Build a bottle for Linux
class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  # Pinned at `5.7.*`
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.28.tar.gz"
  sha256 "f16399315212117c08f9bdf8a0d682728b2ce82d691bcfbf25a770f413b6f2da"

  bottle do
    sha256 "49c493fa62c2d02d54d9f11f7e90818556338e871f2352029e65912e56638cd0" => :catalina
    sha256 "8e49ca1ca574972bb6ba2c32e42d9d4587d2f0ca170b3a6e95eb2d0109901d24" => :mojave
    sha256 "b107088a2c71f87d29d453b556554502c19a863cc7e3cf541afb38c46795503e" => :high_sierra
  end

  keg_only "conflicts with mysql"

  depends_on "cmake" => :build

  depends_on "openssl@1.1"
  uses_from_macos "libedit"

  def install
    # https://bugs.mysql.com/bug.php?id=87348
    # Fixes: "ADD_SUBDIRECTORY given source
    # 'storage/ndb' which is not an existing"
    inreplace "CMakeLists.txt", "ADD_SUBDIRECTORY(storage/ndb)", ""

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
