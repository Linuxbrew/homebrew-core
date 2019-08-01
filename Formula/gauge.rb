class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.5.tar.gz"
  sha256 "45087c236df5a16ff7b3ca3cc9c0a448cd304e8557ba9ccb9ebd22aee2b09124"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be3ce930d0b5da738def3f33a45dc08e56087a703b5d88cc30cae46a3851be66" => :mojave
    sha256 "c0e163247633803520521ff4766026fa453972cd16ff418076afd59e8b79d27d" => :high_sierra
    sha256 "c93467dc6f4602198f51bd9c6f5926fdf2a676eef36f832e5ab9f9f5b2189445" => :sierra
    sha256 "20b776bba34b9f8563b7776ace1a0e115abdb7e84c8e0f89abef216f1b714c72" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
    cd dir do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
