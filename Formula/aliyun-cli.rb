class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.51.tar.gz"
  sha256 "2f710a087e1e088d1d831354e286e8f469dcf6843a1b925c71bac07ce1b7e774"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "302961a8c137daa5b9b4e7ea7a20c59adb4e0ed9a11051bd997687ee7760ae5c" => :catalina
    sha256 "00578e542f6f61c9c94c076e1eff813bbbbc576f1eaf5cf7f2223fe72ff7eff9" => :mojave
    sha256 "a5a38c0c3e650d50a55041424d5afe22b2feafe7bdfcaef145412b09201aa2b6" => :high_sierra
    sha256 "93ca5824047b6d80a5ddf64318049633bfca5d976c46634abfbed63a1cde16a3" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
      prefix.install_metafiles
    end
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
