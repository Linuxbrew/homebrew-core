class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.43.1-src.tar.gz"
    sha256 "cde177b4a8c687da96f20de27630a1eb55c9d146a15e4c900d5c31cd3c3ac41d"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag      => "0.44.1",
          :revision => "2cbe9048efc5c904b33191d799f97dc4698debaa"
    end
  end

  bottle do
    sha256 "ed2a0f6af491d1f7c9733cd32f0518281bc9bcb5f418e62c3fefd582a0f66b2f" => :catalina
    sha256 "53dff98ebf7561798da4c21af2bbe49ccdb6da3c66a45b667031c67432c9e65a" => :mojave
    sha256 "f93422b8fa5616fb2cfba7bdf755c0e57892cbb26ee0276794aabfbde110e7e6" => :high_sierra
    sha256 "92fb7f81f62bd52869fe9335b5756932333d4fcce2fb67f2bb6d49999e5c42a6" => :x86_64_linux
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  depends_on "binutils" unless OS.mac?

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    if OS.mac?
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-03-12/cargo-0.43.0-x86_64-apple-darwin.tar.gz"
      sha256 "92d4c9fb4747dce158cdfb773651aea8eac894277f3a2de5aa2c3b9d92439d8e"
    elsif OS.linux?
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-03-12/cargo-0.43.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "97dde85ea43ccff8202fb77c4d1a5987c3332e578b852b82b426ecff2fa5a9a2"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    args = ["--prefix=#{prefix}"]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path . --features curl-sys/force-system-lib-on-osx]
      args -= %w[--features curl-sys/force-system-lib-on-osx] unless OS.mac?
      system "cargo", "install", *args
    end

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
