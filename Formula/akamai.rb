class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.3.2.tar.gz"
  sha256 "0c1eb4ce261ca35a175d78725c415dce227885f4978e9aa4242102133cb7a5ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3022b69636cc10407739c3497d6fd4250ded19ce0729415699efc2799720134" => :sierra
    sha256 "d3e72e38b1d1b66adb10ec4f230873b78bc12b9cbe8ba1877b2ebe237f264af0" => :el_capitan
    sha256 "01c4c5f3da394c43280aa5546fc70af4c7ff8b2f015e3e78cde9ee3f14a720da" => :yosemite
    sha256 "0c54fc44cc3205d88c785ee056a313f01b6f8e544ef0bf11810f5d9c60352297" => :x86_64_linux # glibc 2.19
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
    end
  end

  test do
    assert_match "Purge", shell_output("yes y | #{bin}/akamai install purge")
  end
end
