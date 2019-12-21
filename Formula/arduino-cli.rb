# arduino-cli: Build a bottle for Linux
class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.7.0",
     :revision => "3809fc3f2ca80404e4ccc3be4f2e44ded2462656"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c250a71de4a4c4ca0a0307a2edf955c14ea3ffd39ea5dc732b56f0beef1a0669" => :mojave
    sha256 "72a668936f974e1512d24b7fbd1969c3c8861b7cd0493da119d3fb957d4ff3c5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
           "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} " \
           "-X github.com/arduino/arduino-cli/version.commit=#{commit}",
           "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
