class GoAT113 < Formula
  desc "Go programming environment (1.13)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.13.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.13.13.src.tar.gz"
  sha256 "ab7e44461e734ce1fd5f4f82c74c6d236e947194d868514d48a2b1ea73d25137"
  license "BSD-3-Clause"

  bottle do
    sha256 "00b0872d51599997c7ff5732476a50f5efa1168c5ea12441ed0ab1c4a9b2204e" => :catalina
    sha256 "4db5e629288d81809d8c59f3a547911a331c88726bd7f2c4d8c5bfd9c426b557" => :mojave
    sha256 "c3f91839dd86a103da3d20fd89290c77bffe80add4433cddb86ba437bfb89be4" => :high_sierra
    sha256 "95937d4270f4510f6a4f7067ed50ff701d15587ec1a470e03d1b8f99dca8c96e" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on :macos => :el_capitan

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.13"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    on_macos do
      url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
      sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
    end

    on_linux do
      url "https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz"
      sha256 "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95"
    end
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = OS.mac? ? "darwin" : "linux"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
