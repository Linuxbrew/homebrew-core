class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.097.0.tar.gz"
    sha256 "1f8f1bcc23c2d4d8254b6b0c34cecbeba69195d8b3d5c52c1b2ed68c1dcd3ac0"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.097.0.tar.gz"
      sha256 "9de7aaa57da5e8a6ab922ac455e9667b1c8bdd6a0df298662ae908cfa1304836"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.097.0.tar.gz"
      sha256 "720d4b8c71cfa31411aa94a5040673f384b06f7da6f1233e726224f9d62180e8"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.097.0.tar.gz"
      sha256 "39bfc5e32ec400f8b4c8931e3f7353036f5840f5439acbb746a2272d02a7f5b3"
    end
  end

  bottle do
    sha256 big_sur:      "7b13c3953ee766dd708d49f739acc6c211441bf849a09ea8cffc7da1a26b47da"
    sha256 catalina:     "fe1f3676f1a382ea3ff1086e2e0a2446c8eff174387d02a263bec32a72104b95"
    sha256 mojave:       "ac360eb79ccbdbd555fc6795b189f8f71aa2eebe2d9b37c272935af2c5033c33"
    sha256 x86_64_linux: "9ace89f2655ff890adc2c5bb99c29a7ce459f724a40f12c67759f50a47480c72" # linuxbrew-core
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  depends_on arch: :x86_64

  uses_from_macos "unzip" => :build
  uses_from_macos "xz" => :build

  def install
    # DMD defaults to v2.088.0 to bootstrap as of DMD 2.090.0
    # On MacOS Catalina, a version < 2.087.1 would not work due to TLS related symbols missing

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      -f posix.mak
    ]

    dmd_make_args = %W[
      SYSCONFDIR=#{etc}
      TARGET_CPU=X86
      AUTO_BOOTSTRAP=1
      ENABLE_RELEASE=1
    ]

    system "make", *dmd_make_args, *make_args

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    on_macos do
      bin.install "generated/osx/release/64/dmd"
    end
    on_linux do
      bin.install "generated/linux/release/64/dmd"
    end
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
