class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"
  revision 1 unless OS.mac?

  stable do
    url "https://github.com/dlang/dmd/archive/v2.077.0.tar.gz"
    sha256 "15cf389248c41744fdc382154a95dfd92056f2af7c2c3153ce5f4e52f041f43c"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.077.0.tar.gz"
      sha256 "d0d4c8f8b5c2084718091bb3f599888063a40e29cb3a9cca6f294386f45a6cc0"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.077.0.tar.gz"
      sha256 "41c1de92adb95facaddea0013d25391fc966494592b6c3255dc3118df6175b38"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.077.0.tar.gz"
      sha256 "422985a812301e3c25e663d9816be27c5985ff6d300b952e2a4805c8792a7dfa"
    end
  end

  bottle do
    sha256 "6ccd402fc38b4913a18ae743b213e1932217fd2aad6e7f640fd68679be0e97fe" => :high_sierra
    sha256 "90f298ed85cb2bce3bad4e1cc90ceb04b43f451f350086dac660d05d7daa621c" => :sierra
    sha256 "69171480cfbc66a8567aec052ab7db8d3d7ad236063084d290688d69da0e5d29" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.077.0-beta.2.tar.gz"
    sha256 "398b799c900344c541d13d93cef5c6809391bed01a7191b72da562681e45e2e7"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.077.0-beta.2.tar.gz"
      sha256 "a21a5c9833d38b5a56c1a7b59060f8d84bc2ad6826fb4524d898a284120a2a95"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.077.0-beta.2.tar.gz"
      sha256 "026f5c52ecee0fe815fd50d8fa230bcf2a35639a2e34964b44e3be01eb3452bb"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.077.0-beta.2.tar.gz"
      sha256 "cc3957e5021fcb3994538d21e765a5a585f9304d48bd370e3b594eb6001d6ef8"
    end
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

  depends_on "unzip" => :build unless OS.mac?

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"
    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

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
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
