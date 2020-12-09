class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.6.tar.gz"
  sha256 "ae826943badd5377d15e247d722c4dc8ea6ecfd5c54cdec93b90f4a5136ea00b"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "068904d828569f25fdac3295d1bf2a5f2b40cd2b62078609b6bc2c41a67508f1" => :big_sur
    sha256 "5584c9c4b970fd3b694a58c2ca5d952a170c127f10d0a0d9bed335a9527dc6e9" => :catalina
    sha256 "478cb19879b903805aed5820fa098a993867fd1870376581ca31b1ef2c35c5a4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
