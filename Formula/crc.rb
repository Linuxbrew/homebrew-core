class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.10.0",
      :revision => "9025021f545acab4c3e3016bed0172490ce53c72"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14180b123d70eb87176d98d4953b3a6f9965ffaf789be18643bbeaed9dd26a0e" => :catalina
    sha256 "8dfd8898768fef9aa17d6d3348aefad034a678ed7c3f0d162ebae696041c920b" => :mojave
    sha256 "cd8bc4a64283ed6e3dd0a52d35f196d9f690f555671390de00a4fe0c95dbf767" => :high_sierra
    sha256 "655e5a5582c3e7a694856aec6c2ccaf899216f63167571bc41f85f3ceaa0b375" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    os = OS.mac? ? "macos" : "linux"
    system "make", "out/#{os}-amd64/crc"
    bin.install "out/#{os}-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    if Process.uid.zero?
      assert_match "crc should be ran as a normal user", status_output
    else
      assert_match "Unable to set ownership", status_output
    end
  end
end
