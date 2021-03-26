class Swift < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.4-RELEASE.tar.gz"
  sha256 "421dafdb0dd4c55cdfed4d8736e965b42a0d97f690bb13528947f9cc3f7ddca9"
  license "Apache-2.0"

  livecheck do
    url "https://swift.org/download/"
    regex(/Releases<.*?>Swift v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    sha256 catalina: "26e59645661eaeea4b9c59deea4dd5591dedce7c74b20c772f2e82ab3450d678"
    sha256 mojave:   "b49fe185bb64ab86515c9b51d43046aad807fa70e49668a403385a72cc4a70b7"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE#system-requirements
  depends_on xcode: ["12.2", :build]

  depends_on "python@3.9"

  uses_from_macos "llvm" => :build
  uses_from_macos "curl"
  uses_from_macos "icu4c"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    resource "six" do
      url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
      sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/swift-5.4-RELEASE.tar.gz"
      sha256 "28f2033b6bdaf0d6d0984fb3f85fafad351b0511a5b99293b2b3ba561cb27f05"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/swift-5.4-RELEASE.tar.gz"
      sha256 "bafbcc1feaf8ac3a82edffde27b85820936cbfd0d194c9c1a320a13c356083c0"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/swift-5.4-RELEASE.tar.gz"
      sha256 "aaf8a15b9ff5fde88ba594364a39534f2302ed9c6c5c251c54c93f71f0860c26"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "1b49d4e87f445f5dbf044e2e29690650618bea811acb82fa2b2eaab5a766a907"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "ca30ea99bdad03b80939c74899ddcd7cc7e2a55d36fe357f98ff7f620442142e"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "91d3e454fff11b14bf89e6ab2b61bacb39395f92d5aab336923670aaa0a7e2fc"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "53a9afee939ccc36bfcd019a57e3d5ffe36ffa027645f99fd3fae893d4bc69a7"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "743956e1a3fdc70e817604cdd95c4898a98dd51603e48f589134971cdf45c225"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "c3f80427f087e7422bfe0359bda81d1c1a6e2e7295eebdaa559e2323670460e9"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "b12cd6c4f8500a543af139cf2b75fb9c432a773aaba97d04a98d73caa1e659a0"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/swift-5.4-RELEASE.tar.gz"
    sha256 "cc89ac700acbf0fd3cbc722768229ba65f5e9a7e58201d13071ff2c416381508"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/0.4.1.tar.gz"
    sha256 "6743338612be50a5a32127df0a3dd1c34e695f5071b1213f128e6e2b27c4364a"
  end

  # Similar scenario as above - see the above file to find the version to use here.
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/4.0.2.tar.gz"
    sha256 "8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = ""
    install_prefix = "/libexec"
    on_macos do
      toolchain_prefix = "/Swift-#{version}.xctoolchain"
      install_prefix = "#{toolchain_prefix}/usr"
    end

    ln_sf buildpath, workspace/"swift"
    resources.each do |r|
      next if r.name == "six"

      r.stage(workspace/r.name)
    end

    # Fix C++ header path. It wrongly assumes that it's relative to our shims.
    on_macos do
      inreplace workspace/"swift/utils/build-script-impl",
                "HOST_CXX_DIR=$(dirname \"${HOST_CXX}\")",
                "HOST_CXX_DIR=\"#{MacOS::Xcode.toolchain_path}/usr/bin\""
    end

    # Disable invoking SwiftPM in a sandbox while building some projects.
    # This conflicts with Homebrew's sandbox.
    helpers_using_swiftpm = [
      workspace/"indexstore-db/Utilities/build-script-helper.py",
      workspace/"sourcekit-lsp/Utilities/build-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"

    # Fix finding of brewed sqlite3.h.
    on_linux do
      inreplace workspace/"swift-tools-support-core/Sources/TSCclibc/include/module.modulemap",
                "header \"csqlite3.h\"",
                "header \"#{Formula["sqlite3"].opt_include/"sqlite3.h"}\""
    end

    # Fix swift-driver somehow bypassing the shims.
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_C_COMPILER:=clang",
              "-DCMAKE_C_COMPILER:=#{which(ENV.cc)}"
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_CXX_COMPILER:=clang++",
              "-DCMAKE_CXX_COMPILER:=#{which(ENV.cxx)}"

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink stdlib sdk-overlay
        tools editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
      ]

      on_macos do
        llvm_components << "dsymutil"
      end
      on_linux do
        swift_components += %w[
          autolink-driver
          sourcekit-inproc
        ]
        llvm_components << "lld"
      end

      pre_args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build
      ]
      post_args = %W[
        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --build-swift-dynamic-stdlib
        --build-swift-dynamic-sdk-overlay
        --build-swift-stdlib-unittest-extra
        --swift-include-tests=0
        --llvm-include-tests=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-swiftpm
        --install-swift-driver
        --install-sourcekit-lsp
      ]

      on_macos do
        post_args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=macosx-#{Hardware::CPU.arch}
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --lldb-no-debugserver
          --lldb-use-system-debugserver
          --extra-cmake-options=-DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
        ]
      end
      on_linux do
        pre_args += %w[
          --libcxx
          --foundation
          --libdispatch
          --xctest
        ]
        extra_cmake_options = %W[
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC=#{Formula["icu4c"].opt_lib}/libicuuc.so
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N=#{Formula["icu4c"].opt_lib}/libicui18n.so
        ]
        post_args += %W[
          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --install-libcxx
          --install-foundation
          --install-libdispatch
          --install-xctest
          --extra-cmake-options=#{extra_cmake_options.join(" ")}
        ]

        venv_root = workspace/"venv"
        venv = virtualenv_create(venv_root, "python3")
        venv.pip_install resource("six")
        ENV.prepend_path "PATH", venv_root/"bin"
      end

      ENV["SKIP_XCODE_VERSION_CHECK"] = "1"
      system "#{workspace}/swift/utils/build-script", *pre_args, "--", *post_args
    end

    on_linux do
      bin.install_symlink Dir["#{libexec}/bin/{swift,sil,sourcekit}*"]
      man1.install_symlink libexec/"share/man/man1/swift.1"
      elisp.install_symlink libexec/"share/emacs/site-lisp/swift-mode.el"
      doc.install_symlink Dir["#{libexec}/share/doc/swift/*"]
    end

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}/bin/*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        The toolchain has been installed to:
          #{opt_prefix}/Swift-#{version}.xctoolchain

        You can find the Swift binary at:
          #{opt_prefix}/Swift-#{version}.xctoolchain/usr/bin/swift

        You can also symlink the toolchain for use within Xcode:
          ln -s #{opt_prefix}/Swift-#{version}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version}.xctoolchain
      EOS
    end
  end

  test do
    toolchain_prefix = ""
    on_macos do
      toolchain_prefix = "/Swift-#{version}.xctoolchain/usr"
    end

    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{prefix}#{toolchain_prefix}/bin/swift -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https://swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{prefix}#{toolchain_prefix}/bin/swift -v foundation-test.swift")
    assert_match "swift.org\n", output

    # Test compiler
    system "#{prefix}#{toolchain_prefix}/bin/swiftc", "foundation-test.swift"
    output = shell_output("./foundation-test")
    assert_match "swift.org\n", output
  end
end
