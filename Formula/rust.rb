class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.47.0-src.tar.gz"
    sha256 "3185df064c4747f2c8b9bb8c4468edd58ff4ad6d07880c879ac1b173b768d81d"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.47.0",
          revision: "149022b1d8f382e69c1616f6a46b69ebf59e2dea"
    end
  end

  bottle do
    sha256 "9658dfa0ecf5f57b14223b56d60c4d303db1939174ae3bd9c3aea2918c3fafb6" => :big_sur
    sha256 "643cb64baa823b8db5e7a4848ec157f45811db9891a641569a3963b0a6d75c6d" => :catalina
    sha256 "5d24baae2f6e47a826849f61b7ac370dcfd3616802617b41a82501cc576e9e3f" => :mojave
    sha256 "eba5a173f9a7db88af4999c3ba1743cf564d31f367a5c941147306cb39797ae2" => :high_sierra
    sha256 "d4902d59161504dc8af150cd2ce01e3b4320ddf926862081bd8f33c5b041d2f7" => :x86_64_linux
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-08-27/cargo-0.47.0-x86_64-apple-darwin.tar.gz"
      sha256 "6e8f3319069dd14e1ef756906fa0ef3799816f1aba439bdeea9d18681c353ad6"
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-08-27/cargo-0.47.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30e494f3848d0335870698e438eaa22388d3226c9786aa282e4fd41fb9cd164d"
    end
  end

  # Only download rustc and rust-std if we are on Linux and using brewed glibc
  if OS.linux? && Formula["glibc"].any_version_installed?
    resource "rustc" do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-08-27/rustc-1.46.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c0c740cfb86047ae8131019597f26382a9b8c289eab2f21069f74a5a4976a26"
    end

    resource "rust-std" do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-08-27/rust-std-1.46.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ac04aef80423f612c0079829b504902de27a6997214eb58ab0765d02f7ec1dbc"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

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

    # If we are on Linux and using brewed glibc, install stage0 binaries to #{buildpath}/localrust
    if OS.linux? && Formula["glibc"].any_version_installed?
      resource("rustc").stage do
        system "./install.sh", "--prefix=#{buildpath}/localrust"
      end

      resource("rust-std").stage do
        system "./install.sh", "--prefix=#{buildpath}/localrust"
      end

      resource("cargobootstrap").stage do
        system "./install.sh", "--prefix=#{buildpath}/localrust"
      end

      # Patch stage0 binaries to use Linuxbrew RPATH and interpreter
      keg = Keg.new(prefix)
      ["#{buildpath}/localrust/bin/rustc", "#{buildpath}/localrust/bin/rustdoc",
       "#{buildpath}/localrust/bin/cargo"].concat(Dir["#{buildpath}/localrust/lib/*.so"]).each do |s|
        file = Pathname.new(s)
        keg.change_rpath(file, Keg::PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s) if file.dynamic_elf?
      end

      # Tell the configure script to use the patched local rust install
      args = ["--prefix=#{prefix}", "--enable-local-rust", "--local-rust-root=#{buildpath}/localrust"]
    else
      args = ["--prefix=#{prefix}"]
    end

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
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
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
