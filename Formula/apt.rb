class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://wiki.debian.org/apt"
  url "https://deb.debian.org/debian/pool/main/a/apt/apt_1.9.3.tar.xz"
  sha256 "f84d5028da78de8b60d80c8639d094422947c8fdc918625ed8f23cbce5e59265"
  # tag "linuxbrew"

  bottle do
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "libxslt" => :build
  depends_on "perl" => :build
  depends_on "w3m" => :build
  depends_on "berkeley-db"
  depends_on "bzip2"
  depends_on "docbook"
  depends_on "dpkg"
  depends_on "gcc@6"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "lz4"
  depends_on "zlib"

  fails_with :gcc => "4"
  fails_with :gcc => "5"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  resource "SGMLS" do
    url "https://cpan.metacpan.org/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz"
    sha256 "550c9245291c8df2242f7e88f7921a0f636c7eec92c644418e7d89cfea70b2bd"
  end

  resource "triehash" do
    url "https://github.com/julian-klode/triehash/archive/v0.3.tar.gz"
    sha256 "289a0966c02c2008cd263d3913a8e3c84c97b8ded3e08373d63a382c71d2199c"
  end

  resource "Unicode::GCString" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2019.001.tar.gz"
    sha256 "486762e4cacddcc77b13989f979a029f84630b8175e7fef17989e157d4b6318a"
  end

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  resource "Text::WrapI18N" do
    url "https://cpan.metacpan.org/authors/id/K/KU/KUBOTA/Text-WrapI18N-0.06.tar.gz"
    sha256 "4bd29a17f0c2c792d12c1005b3c276f2ab0fae39c00859ae1741d7941846a488"
  end

  resource "YAML::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
    sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4222.tar.gz"
    sha256 "e74b45d9a74736472b74830599cec0d1123f992760f9cd97104f94bee800b160"
  end

  resource "Pod::Parser" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz"
    sha256 "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd"
  end

  resource "po4a" do
    url "https://github.com/mquinson/po4a/releases/download/v0.56/po4a-0.56.tar.gz"
    sha256 "d95636906bf71d9ce5131f57045b84c46ae33417346e2437a90013ee01e7d04f"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV.prepend_path "PATH", bin

    (buildpath/"gtest").install resource("gtest")

    resource("Unicode::GCString").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Locale::gettext").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Term::ReadKey").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Text::WrapI18N").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("YAML::Tiny").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("SGMLS").stage do
      chmod 644, "MYMETA.yml"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Module::Build").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Pod::Parser").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("triehash").stage do
      bin.install "triehash.pl" => "triehash"
    end

    resource("po4a").stage do
      system "perl", "Build.PL"
      system "./Build"
      system "./Build", "install"
    end

    mkdir "build" do
      system "cmake", "..",
             "-DDPKG_DATADIR=#{Formula["dpkg"].opt_libexec}/share/dpkg",
             "-DDOCBOOK_XSL=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
             "-DBERKELEY_DB_INCLUDE_DIRS=#{Formula["berkeley-db"].opt_include}",
             "-DGTEST_ROOT=gtest/googletest",
             *std_cmake_args
      system "make", "install"
    end

    mkdir_p etc/"apt/apt.conf.d/"
  end

  test do
    assert_equal "apt 1.9.3 (amd64)", shell_output("#{bin}/apt --version").chomp
  end
end
