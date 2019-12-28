# dmd: Build a bottle for Linux
class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.089.1.tar.gz"
    sha256 "4a55f080ab72ce4cbfbece241613636b949cecfad6a8656732b6bebff4c2008c"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.089.1.tar.gz"
      sha256 "740c62c7d8b91b188c9b6d6a4b1f7065ee28620a30d687e1957c8775f9516e46"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.089.1.tar.gz"
      sha256 "003227ea649ee67c2ae0e09035d73abcc0a2e6edd46d439747d787369857a1e9"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.089.1.tar.gz"
      sha256 "b3d7f0d2e4ce6646a5ea5afa49b6b96271e2b23b18676fe91dfd44e8ee59cfa9"
    end
  end

  bottle do
    sha256 "06e90ecc24a0dfa7bc86d57d1651249cd89802b9fd160dd575aa3be2b5db5fdf" => :mojave
    sha256 "7435fd8bd1cf8f4c665749d189e0ce0773463c80b30b170e9942e3890a692c18" => :high_sierra
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

  unless OS.mac?
    depends_on "unzip" => :build
    depends_on "xz" => :build
  end

  def install
    # Older DMD version is used for bootstraping itself - unfortunately version used for that
    # doesn't work on MacOS Catalina due to TLS related APIs missing on the system.
    # We manually overwrite DMD version used for bootstraping until upstream catches up.
    old_host_dmd_ver="2.079.1"
    host_dmd_ver="2.088.1"

    make_args = %W[
      INSTALL_DIR=#{prefix}
      MODEL=64
      BUILD=release
      HOST_DMD_VER=#{host_dmd_ver}
      -f posix.mak
    ]

    dmd_make_args = %W[
      SYSCONFDIR=#{etc}
      TARGET_CPU=X86
      AUTO_BOOTSTRAP=1
      ENABLE_RELEASE=1
    ]

    # Even though we pass HOST_DMD_VER to makefile, build.d still has version hardcoded.
    # We manually overwrite it until upstream catches up.
    inreplace "src/build.d", old_host_dmd_ver, host_dmd_ver
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

    os = OS.mac? ? "osx" : "linux"
    bin.install "generated/#{os}/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    if OS.mac?
      lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.a"]
    else
      lib.install Dir["druntime/**/libdruntime.*", "phobos/**/libphobos2.*"]
    end

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
