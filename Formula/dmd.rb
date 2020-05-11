class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.091.1.tar.gz"
    sha256 "cd6700104ad25416e7928ae0bb0ba36d056f1d3f2553b2a40c8b1a34ed3cfa8b"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.091.1.tar.gz"
      sha256 "a9ecfc9836debdc374108a141ef465df70d8bcd11e60e394706f08d9ada2ec35"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.091.1.tar.gz"
      sha256 "75b0cb8ca8651d2e7ffbf1cb621995b87f1bba19675afc44aab8d119019cfbe0"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.091.1.tar.gz"
      sha256 "15d385c04e46860d2fb8bbe736c9a9f4b2fcd9fdf0a6daf6f801177125660c68"
    end
  end

  bottle do
    sha256 "d04ac18818eb2bfcd8fb29d4f45f9117fc16dbac28506d48c5adb35ad9583c8a" => :catalina
    sha256 "c0d86df59135dd14c30d35b70d5c8255920a181c3f6d2c016cbd9dc9f7aa283b" => :mojave
    sha256 "8840bbca564001feee5495aa9d0752e3cd40b3725c675b6c4d3f3e2cf2edd138" => :high_sierra
    sha256 "697713600833c09ccf820e640ef81401fa7621d93c5362877890868422421529" => :x86_64_linux
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
