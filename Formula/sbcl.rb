class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  stable do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.16/sbcl-1.3.16-source.tar.bz2"
    sha256 "b7dd98017b70aec351ec4475c68438d52f3f6633269a4ae399216b632c9b8863"

    # Fixes CI builds; see https://bugs.launchpad.net/sbcl/+bug/1678347
    patch do
      url "https://github.com/Homebrew/formula-patches/raw/59046765bf0dec14ac7910c51b6656256cd37514/sbcl/patch-float-state-saving.diff"
      sha256 "71544ce39e6216fd3cdd6a6a2d3a845bdf0acc86482840addfeb6de069473eb9"
    end
  end

  bottle do
    sha256 "61e6bffd237780167867996fc82fe3ba884369e9f0131366ffce7ea960fd14fc" => :sierra
    sha256 "55d625750b1125bd5ffe734810182aeef9c2a8b5884040bc2580bfaa6fad3a99" => :el_capitan
    sha256 "ab0aeab4e49f5c087916d9ac85958ae24686d86b23b668bb50b6143fc6e04225" => :yosemite
    sha256 "77ae0288947d72cf0da7de5e00d830154bb51d26439b305b31a320d88e76f43b" => :x86_64_linux
  end

  option "with-internal-xref", "Include XREF information for SBCL internals (increases core size by 5-6MB)"
  option "without-ldb", "Don't include low-level debugger"
  option "without-sources", "Don't install SBCL sources"
  option "without-core-compression", "Build SBCL without support for compressed cores and without a dependency on zlib"
  option "without-threads", "Build SBCL without support for native threads"

  depends_on "zlib" unless OS.mac?

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    if OS.mac?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
      sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
    elsif OS.linux?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.3/sbcl-1.3.3-x86-64-linux-binary.tar.bz2"
      sha256 "e8b1730c42e4a702f9b4437d9842e91cb680b7246f88118c7443d7753e61da65"
    end
  end

  resource "bootstrap32" do
    if OS.mac?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.1.6/sbcl-1.1.6-x86-darwin-binary.tar.bz2"
      sha256 "5801c60e2a875d263fccde446308b613c0253a84a61ab63569be62eb086718b3"
    elsif OS.linux?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.7/sbcl-1.2.7-x86-linux-binary.tar.bz2"
      sha256 "724425fe0d28747c7d31c6655e39fa8c27f9ef4608c482ecc60089bcc85fc31d"
    end
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb11/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    (buildpath/"version.lisp-expr").write('"1.0.99.999"') if build.head?

    bootstrap = MacOS.prefer_64_bit? ? "bootstrap64" : "bootstrap32"
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource(bootstrap)

    command = "#{tmpdir}/src/runtime/sbcl"
    core = "#{tmpdir}/output/sbcl.core"
    xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
    ]
    args << "--with-sb-core-compression" if build.with? "core-compression"
    args << "--with-sb-ldb" if build.with? "ldb"
    args << "--with-sb-thread" if build.with? "threads"
    args << "--with-sb-xref-internal" if build.with? "internal-xref"

    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    if build.with? "sources"
      bin.env_script_all_files(libexec/"bin", :SBCL_SOURCE_ROOT => pkgshare/"src")
      pkgshare.install %w[contrib src]

      (lib/"sbcl/sbclrc").write <<-EOS.undent
        (setf (logical-pathname-translations "SYS")
          '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
            ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
        EOS
    end
  end

  test do
    (testpath/"simple.sbcl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
