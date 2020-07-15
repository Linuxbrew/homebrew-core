class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  license "BSL-1.0"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.093.0.tar.gz"
    sha256 "13ce74bdbde32b89e1c2a06afe0ac4fe2c9a472980fb53cc17568c14108822db"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.093.0.tar.gz"
      sha256 "5aa87192cbf3ae352c2fbdb0aebc6a7687cd9acb2a713e8917c18f18f6c00c74"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.093.0.tar.gz"
      sha256 "3d573973d95a0ed5b2172c47c1316e4665463d7d140425e6a39c2a1796c13797"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.093.0.tar.gz"
      sha256 "7f5ea2c35441a1598689559cd89f215015ea3a945b509a675eb4bc48f5b50335"
    end
  end

  bottle do
    sha256 "8421923d1c803340a015c6a847a867fee5d3b7546639e50b59da30bc1545532c" => :catalina
    sha256 "100374ffdae365e7a3131b068fd9325cd0c1c09780a3787490db8575f90d663b" => :mojave
    sha256 "dfee8c2354a0c948d7f503eb14c5895adfb97700398b11e22baa1314c8aebc16" => :high_sierra
    sha256 "7c2171c6bb6a01b38230cea0a0ced375d1031e40706afb52d191890311fdd06e" => :x86_64_linux
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
