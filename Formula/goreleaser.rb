class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.133.0",
      :revision => "83e401cfa52ba0f5ad75a6116108cdbe587bbb01"

  bottle do
    cellar :any_skip_relocation
    sha256 "02e141b1222fddd674f6076cafcea5a00bb25439ea1ac9976321988a1defe291" => :catalina
    sha256 "50e8e1cfc6f46dbd1ebdbbe07869b0a3da9c7e04cef6b68b968f2adbc6eeff9d" => :mojave
    sha256 "4208603ac17351545ad29602deb14ba5293f6ef060293fc88f91aeffd7a98bc3" => :high_sierra
    sha256 "19de273256d21939a0db6780cd004036fc0b62eed78bf8c947679179ae10c804" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
