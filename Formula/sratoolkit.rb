class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.10.0.tar.gz"
  sha256 "6d2b02bad674cde6b9677a522f62da092da5471d23738976abce8eae5710fa0c"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    sha256 "5666b45a693e675a145503ee348aa9be199b6dd53d8e3582e6a2af2f4f647b94" => :catalina
    sha256 "8d9a22d8cc446e66d66b44e8d8e2bbdf60faaa9cc8166e9c7cad1dd5e98abf8b" => :mojave
    sha256 "3dc2db39ac207dc8ba786ba808105cba4128cc9cb5573a02c28e9a71208886c9" => :high_sierra
  end

  depends_on "hdf5"
  depends_on "libmagic"
  depends_on "perl" unless OS.mac?
  depends_on "pkg-config" => :build unless OS.mac?
  uses_from_macos "libxml2"

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/2.10.0.tar.gz"
    sha256 "4139adff83af213d7880bc80d1c0f5ee9b00c6c4e615d00aa47aaa267e40ed25"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.10.0.tar.gz"
    sha256 "a6cc88e8d12f536dc96d5f60698d0ef4cf2f63e31d3d12d23da39b1de39563e1"
  end

  unless OS.mac?
    resource "which" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
      sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
    end

    resource "build" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-1.92.tar.gz"
      sha256 "cd95173a72e988bdd7270a22699e6c9764b6aed6e6c4c022c623b1ce72040a79"
    end

    resource "tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.108.tar.gz"
      sha256 "3c49482be2b3eb7ddd7e73a5b90cff648393f5d5de334ff126ce7a3632723ff5"
    end

    resource "chdir" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
      sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
    end

    resource "capture" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
      sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
    end

    resource "libxml2" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.11.tar.gz"
      sha256 "aa583d8e7677f944476bd595e3a25a99935ba15ca0b6a50927951e2ab8415ff3"
    end

    resource "libxml" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0201.tar.gz"
      sha256 "e008700732502b3f1f0890696ec6e2dc70abf526cd710efd9ab7675cae199bc2"
    end
  end

  def install
    # sratoolkit seems to have race conditions during the build and exhibit
    # during pacbio util builds
    # Issue: https://github.com/Linuxbrew/homebrew-core/issues/5323
    ENV.deparallelize unless OS.mac?

    ngs_sdk_prefix = buildpath/"ngs-sdk-prefix"
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure",
          "--prefix=#{ngs_sdk_prefix}",
          "--build=#{buildpath}/ngs-sdk-build"
        system "make"
        system "make", "install"
      end
    end

    ncbi_vdb_source = buildpath/"ncbi-vdb-source"
    ncbi_vdb_build = buildpath/"ncbi-vdb-build"
    ncbi_vdb_source.install resource("ncbi-vdb")
    cd ncbi_vdb_source do
      system "./configure",
        "--prefix=#{buildpath/"ncbi-vdb-prefix"}",
        "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
        "--build=#{ncbi_vdb_build}"
      ENV.deparallelize { system "make" }
    end

    # Fix the error: ld: library not found for -lmagic-static
    # Upstream PR: https://github.com/ncbi/sra-tools/pull/105
    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    # Fix the error: undefined reference to `SZ_encoder_enabled'
    # Issue: https://github.com/Linuxbrew/homebrew-core/issues/5323
    inreplace "tools/pacbio-load/Makefile", "-shdf5 ", "-shdf5 -ssz " unless OS.mac?

    system "./configure",
      "--prefix=#{prefix}",
      "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
      "--with-ncbi-vdb-sources=#{ncbi_vdb_source}",
      "--with-ncbi-vdb-build=#{ncbi_vdb_build}",
      "--build=#{buildpath}/sra-tools-build"

    system "make", "install"

    # Remove non-executable files.
    rm_rf [bin/"magic", bin/"ncbi"]

    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      %w[
        which
        build
        tiny
        chdir
        capture
        libxml2
        libxml
      ].each do |r|
        resource(r).stage do
          if File.exist?("Makefile.PL")
            system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
            system "make"
            system "make", "install"
          elsif File.exist?("Build.PL")
            system "perl", "Build.PL", "--install_base", libexec
            system "./Build"
            system "./Build", "install"
          else
            raise "UNKNOWN BUILD SYSTEM"
          end
        end
      end

      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
