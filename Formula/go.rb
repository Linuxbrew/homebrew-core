# go: Build a bottle for Linuxbrew
class Go < Formula
  desc "The Go programming language"
  homepage "https://golang.org"

  stable do
    url "https://storage.googleapis.com/golang/go1.7.1.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.7.1.src.tar.gz"
    version "1.7.1"
    sha256 "2b843f133b81b7995f26d0cb64bbdbb9d0704b90c44df45f844d28881ad442d3"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}",
          :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
    end
  end

  bottle do
    sha256 "341f36ef4172b2df09cf100b873ffcbd1be9f6d39c4c1a190128443277537c30" => :sierra
    sha256 "fdeadb70a2a12bb5fb98e8c7ebe9b9bc9fa8eb7b7ffb0282094e47d3018da4fc" => :el_capitan
    sha256 "b172524cb48d5649cb125c34b50b780593f9a9527d714918ccd433a0bb17dc89" => :yosemite
    sha256 "e43d9abf5a88d17647497ebfc3b728c52fc92926879d9f15b726338b0c01e745" => :mavericks
  end

  head do
    url "https://github.com/golang/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  depends_on :macos => :mountain_lion

  # Should use the last stable binary release to bootstrap.
  # More explicitly, leave this at 1.7 when 1.7.1 is released.
  resource "gobootstrap" do
    if OS.mac?
      url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
      sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
    elsif OS.linux?
      url "https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz"
      sha256 "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95"
    end
    version "1.7"
  end

  def os
    OS.mac? ? "darwin" : "linux"
  end

  def install
    ENV.permit_weak_imports

    # Fix error: unknown relocation type 42; compiled without -fpic?
    # See https://github.com/Linuxbrew/linuxbrew/issues/1057
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = os
      ENV["CGO_ENABLED"]  = build.with?("cgo") ? "1" : "0"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if MacOS.prefer_64_bit? && build.with?("race")
      system bin/"go", "install", "-race", "std"
    end

    if build.with? "godoc"
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
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

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end
  end
end
